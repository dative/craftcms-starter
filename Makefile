# Variables
CRAFT_PATH 				:= cms
DDEV_PATH 				:= .ddev
SRC_PATH 					:= src
DEFAULT_SITE_NAME := "Dative Boilerplate"
ADMIN_USERNAME 		:= info@hellodative.com

project-name = craft-project

# Source the shell script function tasks
TASKS_FN         := source .boilerplate/bin/tasks.sh


.PHONY: setup
# setup: ddev-setup cms-setup frontend-setup
setup: ddev-setup

# DDEV setup sub-task
.PHONY: ddev-setup
ddev-setup:
	@${TASKS_FN} && ddev_setup


# CMS setup sub-task
.PHONY: cms-setup
cms-setup:
	@${TASKS_FN} && cms_setup

# Frontend setup sub-task
.PHONY: frontend-setup
frontend-setup:
	@echo "Setting up frontend..."
	@if [ ! -d "$(SRC_PATH)" ]; then \
		echo "Copying .boilerplate/src to src"; \
		cp -r .boilerplate/src src; \
	fi
	@for file in $(shell find .boilerplate/devtools -type f ! -name ".*" -not -path "*.DS_Store*" -exec basename {} \;); do \
		if [ ! -f "$$file" ]; then \
			echo "Copying .boilerplate/devtools/$$file to $$file"; \
			cp .boilerplate/devtools/$$file $$file; \
		fi; \
	done
	@if [ ! "$(shell ddev status --json | jq -r '.running')x" = "truex" ]; then \
		echo "Starting DDEV..."; \
		ddev start; \
	fi
	@if [ ! -d "node_modules" ]; then \
		echo "Installing npm dependencies..."; \
		ddev npm install; \
	fi




.PHONY: ddev-up
ddev-up:
	@if [ ! "$$(ddev describe | grep OK)" ]; then \
		ddev start; \
	else \
		echo "\033[34mDDEV is already running.\033[0m"; \
	fi

.PHONY: tester
tester:
	@${TASKS_FN} && tester
