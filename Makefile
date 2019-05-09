#
# Docker-Helferlein
#
# (C) 2019, Ondics GmbH
#

APP_NAME=de-ondics-launchpad-sidecar-registration
export HOST_IP=192.168.1.107

# help-systematik
# build muss phony sein (forcierter build), weil es 
# als verzeichnis existiert und sonst nie gebaut werden würde
.PHONY: help build

help:
	@echo "# Docker-Helferlein"
	@echo "# (C) Ondics, 2019"
	@echo Befehle: make ...
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

# hier die befehle

up:	## Container starten
	docker-compose up -d

down: ## alle Container stoppen
	docker-compose down --remove-orphans
	
build: ## alle Container bauen
	docker-compose build

ps: ## was läuft?
	docker-compose ps
	
bash: ## Die bash im php Container starten
	docker-compose exec $(APP_NAME) bash
	
logs: ## Alle stdout's aller Container zeigen
	docker-compose logs -f -t
    
