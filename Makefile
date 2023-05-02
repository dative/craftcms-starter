###################################################
# 	Variables                                     #
#                                                 #
# 	Uncomment and set the variables to override 	#
# 	the defaults.                                 #
#                                                 #
###################################################

# System defaults
SHELL = /bin/sh

CRAFT_PATH				:= cms
DDEV_PATH					:= .ddev
SRC_PATH					:= src
DEFAULT_SITE_NAME	:= "Dative Boilerplate"
ADMIN_USERNAME		:= info@hellodative.com

# Source the shell script function tasks
mkfile_path 			:= $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir 				:= $(dir $(mkfile_path))
TASKS_DIR        	:= "${mkfile_dir}.bin"

ifdef DDEV_PATH
	TASK_VARS			 += DDEV_PATH=${DDEV_PATH}
endif

ifdef CRAFT_PATH
	TASK_VARS			 += CRAFT_PATH=${CRAFT_PATH}
endif

ifdef SRC_PATH
	TASK_VARS			 += SRC_PATH=${SRC_PATH}
endif

ifdef DEFAULT_SITE_NAME
	TASK_VARS			 += DEFAULT_SITE_NAME=${DEFAULT_SITE_NAME}
endif

ifdef ADMIN_USERNAME
	TASK_VARS			 += ADMIN_USERNAME=${ADMIN_USERNAME}
endif

ifdef TASKS_DIR
	TASK_VARS			 += TASKS_DIR=${TASKS_DIR}
endif

.PHONY: setup-project ddev-setup cms-setup buildchain-setup ping tester run-test-install

setup-project: ddev-setup buildchain-setup cms-setup post-install-clean-up

ddev-setup:
	@${TASK_VARS} bash ${TASKS_DIR}/ddev_setup.sh

cms-setup:
	@${TASK_VARS} bash ${TASKS_DIR}/cms_setup.sh

buildchain-setup:
	@${TASK_VARS} bash ${TASKS_DIR}/buildchain_setup.sh

post-install-clean-up:
	@${TASK_VARS} bash ${TASKS_DIR}/post_install_clean_up.sh
	@echo "Post install clean up..."
	@rm Makefile
	@rm -rf ${TASKS_DIR}

stage-install:
	@${TASK_VARS} bash ${TASKS_DIR}/run_test_install.sh

delete-test-install:
	@${TASK_VARS} bash ${TASKS_DIR}/delete_test_install.sh

tester:
	@${TASK_VARS} bash ${TASKS_DIR}/tester.sh

ping:
	@echo "pong"

run-test:
	@./test/bats/bin/bats test/test.bats

.DEFAULT_GOAL := setup-project