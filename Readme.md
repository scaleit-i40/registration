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
          - APP_TITLE=ScaleIT Pacman
          - APP_SHORT_DESCRIPTION=ScaleIT Pacman
          - APP_DESCRIPTION=ScaleIT Pacman Web-Game
          - APP_DOMAIN_DESCRIPTION=ScaleIT Pacman
          - APP_CATEGORY=domainApp
          - APP_DOMAIN_PORT=${APP_DOMAIN_PORT}
          - APP_DOMAIN_PATH=/
          - APP_DOMAIN_SERVICENAME=
          - APP_ICON_PORT=${APP_SIDECAR_WEBCONTENT_PORT}
          - APP_ICON_PATH=/icon.png
          - APP_ICON_SERVICENAME=webcontent
          - APP_API_PORT=${APP_SIDECAR_WEBCONTENT_PORT}
          - APP_API_PATH=/
          - APP_API_SERVICENAME=webcontent
          - HOST_IP=${HOST_IPADDR}
          - SSO_ACTIVATED=${ssoproxy}
          - SSO_APP_PREFIX=${DOMAINPREFIX}
          - STACK_NAME={{ .Stack.Name }}

Hinweise:

* APP_DOMAIN_PORT wird als Rancher-Question abgefragt
* APP_ICON_PORT wird als Rancher-Question abgefragt
* APP_SIDECAR_WEBCONTENT_PORT wird als Rancher-Question abgefragt

Bedeutung der Environment-Variablen:

t.b.d.

## Support

Weitere Infos Im [ScaleIT I40 Wiki](https://wiki.scaleit-i40.de).

Für alle  darüber hinaus gibt es das [ScaleIT I40 Forum](https://forum.scaleit-i40.de).


## Lizenz und Autor

Es gilt die  Ondics ScaleIT I40 Open Licence.

Ondics GmbH, Neckarstraße 66/1a, 73728 Esslingen

(C) 2019, Ondics GmbH
