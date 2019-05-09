# ScaleIT I40 Registration Sidecar

Mit diesem Sidecar gibt eine ScaleIT App in ETCD bekannt, dass und wie sie gestartet wurde. 

Sie trägt wichtige Infos über sich in ETCD ein.

## Nutzung

Das Registration-Sidecar muss im ```PlatformSidecars``` Verzeichnis liegen: 

    ./PlatformSidecars/registration
    
Hierzu wird es einmalig geclont:

    $ cd PlatformSidecars
    $ git clone https://github.com/scaleit-i40/registration
    
Alternativ kann es auch als Git-Submodule eingebunden werden.

## Funktionsweise

Im ```docker-compose.yml``` des Rancher-Templates wird das Registration Sidecar eingebaut. 
Für eine App Pacman könnte das so aussehen:

    services:
      ...
      # Registration sidecar
      de-ondics-pacman-registration:
        image: registry.app-pool.scaleit-i40.de/nilsclauss/ondics-dev/de-ondics-pacman-registration:1.1
        restart: always
        environment:
          - APP_ID=de-ondics-pacman
          - APP_NAME=ScaleIT Pacman
          - APP_TITLE=ScaleIT Pacman
          - APP_SHORT_DESCRIPTION=ScaleIT Pacman
          - APP_DESCRIPTION=ScaleIT Pacman Web-Game
          - APP_CATEGORY=domainApp
          - APP_DOMAIN_PORT=${APP_DOMAIN_PORT}
          - APP_DOMAIN_PATH=/
          - APP_DOMAIN_DESCRIPTION=ScaleIT Pacman
          - APP_ICON_PORT=${APP_SIDECAR_WEBCONTENT_PORT}
          - APP_ICON_PATH=/icon.png
          - HOST_IP=${HOST_IPADDR}
          - SSO_ACTIVATED=${ssoproxy}
          - SSO_APP_PREFIX=${DOMAINPREFIX}
          - APP_WEBCONTENT_SERVICENAME=webcontent
          - APP_API_SERVICE=webcontent
          - APP_API_PORT=${APP_SIDECAR_WEBCONTENT_PORT}
          - APP_API_PATH=/

Hinweise:

* APP_DOMAIN_PORT wird als Rancher-Question abgefragt
* APP_ICON_PORT wird als Rancher-Question abgefragt
* APP_SIDECAR_WEBCONTENT_PORT wird als Rancher-Question abgefragt

Bedeutung der Environment-Variablen:

t.b.d.

## Lizenz und Autor

Es gilt die  Ondics Open Licence.

Ondics GmbH
Neckarstraße 66/1a
73728 Esslingen

(C) 2019, Ondics GmbH
