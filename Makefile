###################################################
# 	Variables                                     #
#                                                 #
# 	Uncomment and set the variables to override 	#
# 	the defaults.                                 #
#                                                 #
###################################################

# CRAFT_PATH 				:= cms
# DDEV_PATH 				:= .ddev
# SRC_PATH 					:= src
# DEFAULT_SITE_NAME := "Dative Boilerplate"
# ADMIN_USERNAME 		:= info@hellodative.com

# Source the shell script function tasks
TASKS_DIR        = .boilerplate/bin
TASKS_FN         := sh .boilerplate/bin/tasks.sh

ifdef DDEV_PATH
	TASKS_FN       := DDEV_PATH=${DDEV_PATH} ${TASKS_FN}
endif

ifdef CRAFT_PATH
	TASKS_FN       := CRAFT_PATH=${CRAFT_PATH} ${TASKS_FN}
endif

ifdef SRC_PATH
	TASKS_FN       := SRC_PATH=${SRC_PATH} ${TASKS_FN}
endif

ifdef DEFAULT_SITE_NAME
	TASKS_FN       := DEFAULT_SITE_NAME=${DEFAULT_SITE_NAME} ${TASKS_FN}
endif

ifdef ADMIN_USERNAME
	TASKS_FN       := ADMIN_USERNAME=${ADMIN_USERNAME} ${TASKS_FN}
endif

ifeq '$(findstring ;,$(PATH))' ';'
    UNAME := Windows
else
    UNAME := $(shell uname 2>/dev/null || echo Unknown)
endif

.PHONY: setup-project ddev-setup cms-setup buildchain-setup cms-teardown tester

setup-project: ddev-setup cms-setup buildchain-setup

ddev-setup:
	command -v ddev

cms-setup:
	@${TASKS_FN} cms_setup

cms-teardown:
	@${TASKS_FN} cms_teardown

buildchain-setup:
	@${TASKS_FN} buildchain_setup

tester:
	@sh ${TASKS_DIR}/tester.sh \
		$(filter-out $@,$(MAKECMDGOALS))

%:
	@:
# ref: https://stackoverflow.com/questions/6273608/how-to-pass-argument-to-makefile-from-command-line