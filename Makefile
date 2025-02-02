## ============================================================================
##          Inspired on https://github.com/thevops/makefile-automation
##          Additions by: @yifattih
##          Description: Makefile for common DevOps and software
##                       development taks automation
## ============================================================================

#  Check if the version of Make is 4.3
NEED_VERSION := 4.3
$(if $(filter $(NEED_VERSION),$(MAKE_VERSION)),, \
 $(error error You must be running make version $(NEED_VERSION).))

include subMakefiles/colors.mk
include subMakefiles/utils.mk



# By default Makefile use tabs in indentation. This command allow to use SPACES
# .RECIPEPREFIX +=                      # Make Version < 4.3
.RECIPEPREFIX := $(.RECIPEPREFIX)       # Make Version = 4.3

# By default every line in every task in ran in separate shell.
.ONESHELL:                              # Run all commands in a single shell

# By default Makefile use /bin/sh
SHELL:=/bin/bash

# It enables exiting if there will be error in pipe, eg. something | command | something_else
.SHELLFLAGS := -eu -o pipefail -c

# Optionally load env vars from .env
include .env

ARGS = $(filter-out $@,$(MAKECMDGOALS))
ARG1 := $(word 2, $(ARGS))
ARG2 := $(word 3, $(ARGS))
ARG3 := $(word 4, $(ARGS))
ARG4 := $(word 5, $(ARGS))
ARG5 := $(word 6, $(ARGS))


#-----------------------------------------------------------------------------#
##
##-----------------------------------------------------------------------------
##|                          Git Targets                                      |
##-----------------------------------------------------------------------------
##
#-----------------------------------------------------------------------------#
.PHONY: status
status: ## Show a git status glimpse
##  |Usage:
##  |   $ make status
##
    @ echo
    $(call log,"CHANGES")
    @ git diff --color --stat=$($(tput cols) - 3) HEAD | sed '$d; s/^ //' | sed 's/^/ /'
    @ echo
    $(call log,"FILES SUMMARY")
    $(call log_keyvalue,"Modified", $(shell git status -s | grep "^.*M" | sed "s/^.M / /g"))
    $(call log_keyvalue,"Staged", $(shell git status -s | grep -e "^A.*" -e "^M.*" | grep -v "^.*D" | sed -e "s/^A.* / /g" -e "s/^M.* / /g"))
    $(call log_keyvalue,"Deleted", $(shell git status -s | grep "^.*D " | sed "s/^.*D / /g"))
    $(call log_keyvalue,"Untracked", $(shell git status -s | grep "??" | sed "s/??/ /g"))
    @ echo

log: ## Show custom git log
##  |Usage:
##  |   $ make log <int: number of entries | optional>
##
    @ echo
    $(call log, COMMITS)
    @ # Function to check if the input is an integer
    @ # Script
    if [ -z "$(ARG1)" ]; then \
        $(call log_prompt,"How many entries?"); \
        if ! echo "$$input" | grep -qE '^[0-9]+$$'; then \
            $(call log_error,"Number of log entries must be an integer!") \
            && echo \
            && exit 0;
        fi;
        git --no-pager log -n "$(ARG1)" --abbrev-commit --format=format:"%s-- " | sed "s/-- /\n/g" \
        | sed -r \
        -e 's/([^(:]*)(\([^)]*\))(:)(.*)/ \x1b[30m\1\x1b[0m\x1b[36m\2\x1b[0m\x1b[37m\3\x1b[0m\x1b[33m\4\x1b[0m/g' \
        | tac; \
    elif ! echo "$(ARG1)" | grep -qE '^[0-9]+$$'; then \
        $(call log_error,"Number of log entries must be an integer!") \
        && echo \
		&& exit 0; \
    else \
        git --no-pager log -n "$(ARG1)" --abbrev-commit --format=format:"%s-- " | sed "s/-- /\n/g" \
        | sed -r \
        -e 's/([^(:]*)(\([^)]*\))(:)(.*)/ \x1b[30m\1\x1b[0m\x1b[36m\2\x1b[0m\x1b[37m\3\x1b[0m\x1b[33m\4\x1b[0m/g' \
        | tac; \
    fi;
    @ echo

commit: ## Commit all changes
##  |Usage:
##  |   $ make commit
##
    @ echo
    @ echo -e "\e[32m[=================] \e[0m COMMITING ALL CHANGES \e[32m[=================] \e[0m"
    @ git add .
    @ read -p "Message: " message
    @ if [ -z "$$message" ]; then echo \
    && echo "Commit message is required" \
    && echo "Either:" \
    && echo "- Type a message" \
    && echo "- Type \"editor\" to enter the message using the default text editor" \
    && echo ; exit 1; fi
    @ if [ "$$message" == "editor" ]; then git commit; else git commit -m "$$message"; fi
    @ echo -e "\e[32m[=================] \e[0m                       \e[32m[=================] \e[0m"
    @ echo

.PHONY: commit-file
commit-file: ## Commit specific file
##  |Usage:
##  |   $ make commit-file <str: file | optional> <str: message | optional>
##
    @ echo
    $(call log,"COMMITTING A SINGLE FILE")
    @ if [ -z "$(file)" ]; then \
        git diff --color --stat=$($(tput cols) - 3) HEAD | sed '$d; s/^ //' | sed 's/^/ /'; \
        echo; \
        $(call log_prompt,"Enter file name") && file="$$input"; \
        git add "$$file" 2>/dev/null || { $(call log_error, File "$$file" do not exist!) && echo && exit 0; }; \
        if [ -z "$(message)" ]; then \
            echo; \
            echo " Lets construct the commit message using the AngularJS commit convention!"; \
            $(call log_prompt,Type) && type="$$input"; \
            if [ -z "$$type" ]; then { $(call log_error, "Field can't be empty!") && echo && exit 0; }; fi; \
            $(call log_prompt,Scope) && scope="$$input"; \
            if [ -z "$$scope" ]; then { $(call log_error, "Field can't be empty!") && echo && exit 0; }; fi; \
            $(call log_prompt,Imperative Description) && description="$$input"; \
            if [ -z "$$description" ]; then { $(call log_error, "Field can't be empty!") && echo && exit 0; }; fi; \
            message="$$type($$scope): $$description"; \
        fi; \
        git commit -m "$$message" > /dev/null 2>&1; \

        $(call log_keyvalue,"Commit","$$message"); \
    fi;
    # elif [-z "$(message)"]; then
    #     $(call log_prompt, Enter message); \
    #     git commit -m "$$input"; \
    # else \
    #     git commit -m "$(message);" \
    # fi
    # else \
    #     git add "$(file)" 2>/dev/null || $(call log_error, File "$(file)" do not exist!) \
    #     && echo \
    #     && exit 0;
    # fi
    @ echo

.PHONY: commit-delete
commit-delete: ## Delete last commit message
##  |Usage:
##  |   $ make commit-delete
##
    @ echo
    $(call log, "DELETE COMMIT")
    hash=$(shell git rev-parse --short HEAD)
    $(call log_keyvalue, Hash, $$hash)
    @ git reset --soft HEAD~1
    @ echo

push: ## Push all commited changes to remote
##  |Usage:
##  |   $ make push
    @ echo
    @ echo -e "\e[32m[=================] \e[0m PUSHING TO REMOTE \e[32m[=================] \e[0m"
    @ git push --progress --verbose
    @ echo -e "\e[32m[=================] \e[0m                  \e[32m[=================] \e[0m"
    @ echo

.PHONY: branch
branch: ## Show current branch
##  |Usage:
##  |   $ make branch
##
    @ CURRENT+="$(shell \
                    git branch \
                    | grep "\*" \
                    | sed 's/\*//g' \
                    | sed 's/ //g')"
    @ echo
    $(call log, "BRANCHES")
    $(call log_keyvalue, Current, $$CURRENT)
    @ echo

.PHONY: branch-all
branch-all: ## Show current branches
##  |Usage:
##  |   $ make branch-all
##
    @ CURRENT+="$(shell git branch --show-current)"
    @ LOCAL+="$(shell git branch --format="%(refname:short)")"
    @ REMOTE+="$(shell git branch -r --format="%(refname:short)" | sed "s/origin\///g")"
    @ echo
    $(call log, BRANCHES)
    $(call log_keyvalue, Current, $$CURRENT)
    $(call log_keyvalue, Local, $$LOCAL)
    $(call log_keyvalue, Remote, $$REMOTE)
    @ echo

branch-new: ## Create new local branch
##  |Usage:
##  |   $ make branch-new
##  |   $ make branch-new name=<branch_name>
##
    @ echo
    @ echo -e "\e[32m[=================] \e[0m CREATING NEW BRANCH \e[32m[=================] \e[0m"
    @ if [ -z "$(name)" ]; then read -p "Enter branch name: " branch && git checkout -b $$branch; else git checkout -b $$name; fi
    @ echo -e "\e[32m[=================] \e[0m                     \e[32m[=================] \e[0m"
    @ echo

branch-push: ## Push current local branch to remote
##  |Usage:
##  |   $ make branch-push
##
    @ echo
    @ echo -e "\e[32m[=================] \e[0m PUSHING BRANCH TO REMOTE \e[32m[=================] \e[0m"
    @ git push --set-upstream origin $(shell git rev-parse --abbrev-ref HEAD)
    @ echo -e "\e[32m[=================] \e[0m                          \e[32m[=================] \e[0m"
    @ echo

branch-delete: ## Delete local branch
##  |Usage:
##  |   $ make branch-delete name=<branch_name>
##
    @ echo
    @ echo -e "\e[32m[=================] \e[0m DELETING BRANCH \e[32m[=================] \e[0m"
    @ if [ -z "$(name)" ]; then read -p "Enter branch name: " branch && git branch -d $$branch; else git branch -d $$name; fi
    @ echo -e "\e[32m[=================] \e[0m                 \e[32m[=================] \e[0m"
    @ echo

branch-wipe: ## Delete local/remote branch
##  |Usage:
##  |   $ make branch-remote-delete name=<branch_name>
##
    @ echo
    @ echo -e "\e[32m[=================] \e[0m DELETING LOCAL/REMOTE BRANCH \e[32m[=================] \e[0m"
    @ if [ -z "$(name)" ]; then read -p "Enter branch name: " branch && git push --set-upstream origin --delete $$branch && git branch --delete $$branch; else git push --set-upstream origin --delete $$name && git branch --delete $$name; fi
    @ echo -e "\e[32m[=================] \e[0m                              \e[32m[=================] \e[0m"
    @ echo

#-----------------------------------------------------------------------------#
##
##-----------------------------------------------------------------------------
##|                          Service Targets                                  |
##-----------------------------------------------------------------------------
##
#-----------------------------------------------------------------------------#

run: ## Run the service
##  |Usage:
##  |   $ make run
##
    @ $(info Starting service...)
    export ENV="dev"
    @ honcho start

#-----------------------------------------------------------------------------#
##
##-----------------------------------------------------------------------------
##|                           Docker Targets                                  |
##-----------------------------------------------------------------------------
##
#-----------------------------------------------------------------------------#

build: ## Build and run the project service
##  |Usage:
##  |   $ make build
##
    @ echo -e "\e[32m[=================] \e[0m BUILDING DOCKER IMAGE \e[32m[=================] \e[0m"
    @ read -p "Enter image name: " DOCKER_IMAGE_NAME
    @ read -p "Enter image tag: " DOCKER_IMAGE_TAG
    @ read -p "Enter build context dir: " DOCKER_BUILD_CONTEXT
    @ BUILD_NAME_TAG=$$DOCKER_IMAGE_NAME:$$DOCKER_IMAGE_TAG
    @ LOCAL_PORT=2000
    @ CONTAINER_PORT=8000
    @ cp Procfile api/
    @ docker build -t $$BUILD_NAME_TAG $$DOCKER_BUILD_CONTEXT
    @ rm api/Procfile
    @ docker run -d -p $$LOCAL_PORT:$$CONTAINER_PORT $$BUILD_NAME_TAG
    @ echo "ACCESS THE SERVICE AT: http://localhost:$$LOCAL_PORT"
    @ echo -e "\e[32m[=================] \e[0m                      \e[32m[=================] \e[0m"

# -----------------------------   DO NOT CHANGE   -----------------------------
help:
    @grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) \
        | sed -e 's/^.*Makefile://g' \
        | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' \
        | sed -e 's/\[32m##/[33m/'
    @echo

# Prevents make from treating arguments as targets
%:      # do not change
    @:    # do not change

.DEFAULT_GOAL := help