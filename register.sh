#!/bin/bash

#
# Mit diesem Skript registriert sich eine App beim
# ScaleiT ETCD Service.
# 
# (C) 2019, Ondics GmbH

echo
echo "ScaleIT Registration Sidecar"
echo 
echo "pid: $$"

# 
# Beispiel-Werte (sollten als ENV-Veriablen gesetzt sein
# im docker-compose.yml)
#
# APP_ID="de-ondics-qsreport"
# APP_NAME="QS Report"
# APP_TITLE=
# APP_SHORT_DESCRIPTION=
# APP_DESCRIPTION=
# APP_CATEGORY=domainApp
# APP_DOMAIN_PORT=
# APP_DOMAIN_PATH=
# APP_DONAIN_DESCRIPTION=
# APP_ADMIN_PORT=
# APP_ADMIN_PATH=
# APP_ADMIN_DESCRIPTION=
# APP_ICON_PORT=
# APP_ICON_PATH=


echo "host-ip========= $HOST_IP"

# Rancher-Metadaten holen                                                                                                                                                                                    
RANCHER_HOST_IP=$(curl -s "http://rancher-metadata/2015-12-19/hosts/0/agent_ip")                                                                                                                             
if [ "$RANCHER_HOST_IP" == "" ]; then
  RANCHER_HOST_IP=$HOST_IP           
fi
SSO_DOMAIN="[hostname-fehlt]"                                                                                                                                                                                
SSO_DOMAIN_META=$(curl -s "http://rancher-metadata/latest/services/de-ondics-sso-protect-active/labels/platform_url")                                                                                        
if [ "$SSO_DOMAIN_META" != "" ]; then                                                                                                                                                                        
  SSO_DOMAIN=$SSO_DOMAIN_META                                                                                                                                                                                
fi    

# Default-ETCD, wenn nicht gesetzt
ETCD_HOSTNAME=etcd
ETCD_PORT=49501
if [ -z "$ETCD_URI" ]; then
  if [ -z "$RANCHER_HOST_IP" ]; then
    ETCD_URI=$ETCD_HOSTNAME:$ETCD_PORT
  else
    ETCD_URI=$RANCHER_HOST_IP:$ETCD_PORT
  fi
fi
echo ETCD_URI: $ETCD_URI


#check if etcd is up and running
echo "Check if etcd is up and running ..."
#STR='"health": "false"'
#STR=$(curl -sb -H "Accept: application/json" "http://$ETCD_URI/health")
#while [[ "$STR" != *'"health":"true"'* ]]
STATUS="unhealthy"
while [ "$STATUS" != 'healthy' ]; do
	echo "Waiting for etcd ($ETCD_URI) ..."
	HEALTH_JSON=$(curl -sb -H "Accept: application/json" "http://$ETCD_URI/health")
  echo "HEALTH_JSON=[$HEALTH_JSON]"
  STATUS=$(echo $HEALTH_JSON | sed 's/^.*"health":[[:space:]]*"true".*$/healthy/g')
  echo "Status=[$STATUS]"
	sleep 1
done
echo "etcd is up"

#überprüfen, ob stack-name gesetzt, sonst id verwenden
${STACK_NAME:?"$APP_ID"}
APP_REGISTRY_URL="http://$ETCD_URI/v2/keys/apps/$STACK_NAME"
echo APP_REGISTRY_URL: $APP_REGISTRY_URL

function etcd_add() {
  echo "ETCD: $1 => $2"
  curl --silent -L -X PUT "$APP_REGISTRY_URL/$1" -d value="$2" >> /dev/null
  if [ "$?" != 0 ]; then
    echo "Fehler: ETCD-Schreiben geht nicht"
    exit 1
  fi
}

# Url zusammensetzen für Port und Namen-Adressierung 
# $1 = Pfad
# $2 = Port
# $3 = Servicename
function build_url() {
  if [ "$SSO_ACTIVATED" == "true" ]; then
    if [ "$3" == "" ]; then
      echo "https://$SSO_APP_PREFIX.$SSO_DOMAIN_META$1"
    else
      echo "https://$3-$SSO_APP_PREFIX.$SSO_DOMAIN_META$1"
    fi
  else
    echo "http://$RANCHER_HOST_IP:$2$1"
  fi
}


# Jetzt die Werte nach ETCD schreiben
echo "ScaleIT ETCD aktualisieren:"
etcd_add id "$APP_ID"
etcd_add name "$APP_NAME"
etcd_add title "$APP_TITLE"
etcd_add shortDescription "$APP_SHORT_DESCRIPTION"
etcd_add description "$APP_DESCRIPTION"
etcd_add category "$APP_CATEGORY"

APP_DOMAIN_URL=$(build_url  "$APP_DOMAIN_PATH" "$APP_DOMAIN_PORT" "")
etcd_add domainUrl "$APP_DOMAIN_URL"

#APP_ADMIN_URL=$(build_url "$APP_ADMIN_PATH" "$APP_ADMIN_PORT" "")
#etcd_add adminUrl "$APP_ADMIN_URL"

APP_ICON_URL=$(build_url  "$APP_ICON_PATH" "$APP_ICON_PORT" "$APP_WEBCONTENT_SERVICENAME")
etcd_add iconUrl "$APP_ICON_URL"

APP_API_URL=$(build_url  "$APP_API_PATH" "$APP_API_PORT" "$APP_API_SERVICE")
etcd_add apiUrl "$APP_API_URL"

# ...und Zeitstempel!
etcd_add updatedAt "`date '+%Y-%m-%d %H:%M:%S'`"

echo "Registration completed."


# SIGTERM-handler
# Beim Abbruch (z.B. ctrl-c) App wieder deregistrieren
term_handler() {
  echo "*** Registration Sidecar shut down - START"

  # Eintrag löschen
  echo "*** App deregistrieren"
  curl --silent -L -X PUT "http://$ETCD_URI/v2/keys/apps/$APP_ID?recursive=true" \
    -XDELETE >> /dev/null

  # alternativ: Status auf offline setzen
  #echo "*** App Status auf offline setzen"
  #curl -L -X PUT "$APP_REGISTRY_URL/status" -d value="Offline"

  echo "*** Registration Sidecar shut down - ENDE"

  exit 143; # 128 + 15 -- SIGTERM
}

# setup handlers
# on callback, kill the last background process, 
# which is `tail -f /dev/null` and execute the specified handler
trap 'kill ${!}; term_handler' SIGTERM SIGINT

# wait forever
while true
do
  tail -f /dev/null & wait ${!}
done
