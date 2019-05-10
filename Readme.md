# ScaleIT I40 Registration Sidecar

Mit diesem Sidecar gibt eine ScaleIT App in der ScaleIt App-Registry bekannt, dass und wie sie gestartet wurde. 

Hierzu trägt das Registration Sidecar die App-Daten in der ScaleIT App Registry ETCD ein.

Das Registration Sidecar kann in einer ScaleIT Core CE und EE Umgebung verwendet werden.

Infos zur [ScaleIT App-Registry](https://wiki.scaleit-i40.de/index.php?title=ScaleIT-Komponenten_und_wie_man_damit_arbeitet)

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
          - APP_TITLE=ScaleIT Pacman-Spiel
          - APP_SHORT_DESCRIPTION=ScaleIT Pacman
          - APP_DESCRIPTION=Entspannung pur am Arbeitsplatz - ohne Highscore
          - APP_CATEGORY=other
          - SSO_ACTIVATED=${ssoproxy}
          - SSO_APP_PREFIX=${DOMAINPREFIX}
          - HOST_IP=${HOST_IPADDR}
          - APP_DOMAIN_PORT=${APP_DOMAIN_PORT}
          - APP_DOMAIN_PATH=/
          - APP_DOMAIN_DESCRIPTION=ScaleIT Pacman
          - APP_ICON_PORT=${APP_SIDECAR_WEBCONTENT_PORT}
          - APP_ICON_SERVICE=webcontent
          - APP_ICON_PATH=/icon.png
          - APP_API_PORT=${APP_API_PORT}
          - APP_API_SERVICE=webcontent
          - APP_API_PATH=/api

Hinweise:

* Die URLs werden so erstellt (HOSTNAME wird von Rancher ermittelt):
  * in der CE: [HOST_IP]:[PORT]/[PATH]
  * in der EE: [SERVICE_NAME]-[SSO_APP_PREFIX].[HOSTNAME]/[PATH]
* Die PORT-Angaben werden am besten als Rancher-Question abgefragt


Bedeutung der Environment-Variablen:

| Variable  | Bedeutung | Beispiel |
| ------------- | ------------- | ------------- |
| APP_ID  | ID der App |de-ondics-pacman |
| APP_NAME  | Kurzname  | ScaleIT Pacman |
| APP_TITLE  | Kurzname  (durch Benutzer später änderbar) | Pacman-Spiel |
| APP_SHORT_DESCRIPTION  | Kurze Beschreibung | ScaleIT Pacman |
| APP_DESCRIPTION  | Beschreibung | Entspannung pur am Arbeitsplatz - ohne Highscore |
| APP_CATEGORY  | App-Kategorie (core, digital-twin, workflow, other) | other
| SSO_ACTIVATED  | Ist SSO aktiviert (in EE-Version:true, in CE-Version:false) | false |
| SSO_APP_PREFIX  | Domain-Präfix dieser App | pacman |
| HOST_IP  | TCP/IP-Adresse des Hosts (für CE-Version) | 192.168.1.100 |
| APP_DOMAIN_PORT  | TCP/IP-Port für Benutzeroberfläche | ${APP_DOMAIN_PORT}
| APP_DOMAIN_PATH  | Pfad für Benutzeroberfläche | / |
| APP_DOMAIN_DESCRIPTION  | kurze Beschreibung der App | Benutzer-Oberfläche für Spiel |
| APP_ICON_PORT  | TCP/IP-Port des Icon-Servcies (für CE-Version) | ${APP_ICON_PORT}
| APP_ICON_SERVICE  | Name des Icon-Servcies (für EE-Version) | webcontent |
| APP_ICON_PATH  | Pfad zum Icon | /icon.png |
| APP_API_PORT  | TCP/IP-Port des API-Servcies (für CE-Version) | ${APP_API_PORT}
| APP_API_SERVICE | Name des API-Servcies (für EE-Version) | webcontent |
| APP_API_PATH  | Pfad zur API | /api |


## Support

Weitere Infos Im [ScaleIT I40 Wiki](https://wiki.scaleit-i40.de).

Für alle  darüber hinaus gibt es das [ScaleIT I40 Forum](https://forum.scaleit-i40.de).


## Lizenz und Autor

Es gilt die  Ondics ScaleIT I40 Open Licence.

Ondics GmbH, Neckarstraße 66/1a, 73728 Esslingen

(C) 2019, Ondics GmbH
