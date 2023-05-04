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

# Macros
args = `arg="$(filter-out $@,$(MAKECMDGOALS))" && echo $${arg:-${1}}`

.PHONY: ddev-setup buildchain-setup cms-setup stage-install

setup-project: ddev-setup buildchain-setup cms-setup post-install-clean-up

install-ddev:
	@${TASK_VARS} bash ${TASKS_DIR}/ddev_setup.sh

install-buildchain:
	@${TASK_VARS} bash ${TASKS_DIR}/buildchain_setup.sh

install-cms:
	@${TASK_VARS} bash ${TASKS_DIR}/cms_setup.sh

post-install-clean-up:
	@${TASK_VARS} bash ${TASKS_DIR}/post_install_clean_up.sh
	@echo "Post install clean up..."
	@rm Makefile
	@rm -rf ${TASKS_DIR}

stage-install:
	@${TASK_VARS} bash ${TASKS_DIR}/stage_install.sh \
		$(filter-out $@,$(MAKECMDGOALS)) $(MAKEFLAGS)

delete-stage-install:
	@${TASK_VARS} bash ${TASKS_DIR}/delete_stage_install.sh

tester:
	@${TASK_VARS} bash ${TASKS_DIR}/tester.sh \
		$(filter-out $@,$(MAKECMDGOALS)) $(MAKEFLAGS)

split:
	@echo $(filter-out $@,$(MAKECMDGOALS)) $(filter-out " -- ", ${MAKEFLAGS})

ping:
	@echo "pong"

run-test:
	@./test/bats/bin/bats test/test.bats

%:
	@:
# ref: https://stackoverflow.com/questions/6273608/how-to-pass-argument-to-makefile-from-command-line

.DEFAULT_GOAL := ping
