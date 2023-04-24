# Variables
CRAFT_PATH 				:= cms
DDEV_PATH 				:= .ddev
SRC_PATH 					:= src
DEFAULT_SITE_NAME := "Dative Boilerplate"
ADMIN_USERNAME 		:= info@hellodative.com

# Source the shell script function tasks
TASKS_FN         := .boilerplate/bin/tasks.sh

.PHONY: setup-project
setup-project: ddev-setup cms-setup buildchain-setup

.PHONY: ddev-setup
ddev-setup:
	@sh ${TASKS_FN} ddev_setup

.PHONY: cms-setup
cms-setup:
	@sh ${TASKS_FN} cms_setup

.PHONY: cms-teardown
cms-teardown:
	@sh ${TASKS_FN} cms_teardown

.PHONY: buildchain-setup
buildchain-setup:
	@sh ${TASKS_FN} buildchain_setup

.PHONY: tester
tester:
	@sh ${TASKS_FN} tester
