# source: https://github.com/thevops/makefile-automation
# additions by: $yifattih
# Description: Makefile for automation tasks

# By default Makefile use tabs in indentation. This command allow to use SPACES
# .RECIPEPREFIX +=                      # Make Version < 4.3
.RECIPEPREFIX := $(.RECIPEPREFIX)       # Make Version >= 4.3

# By default every line in every task in ran in separate shell.
.ONESHELL:                              # Run all commands in a single shell

# By default Makefile use /bin/sh
SHELL:=/bin/bash

# It enables exiting if there will be error in pipe, eg. something | command | something_else
.SHELLFLAGS := -eu -o pipefail -c

# Optionally load env vars from .env
include .env

args=$(filter-out $@,$(MAKECMDGOALS))

##
## ----------------------------------------------------------------------------
##   NAME
## ----------------------------------------------------------------------------
##


#------------------------------------------#
##              Git group
#------------------------------------------#

gcmt: ## Commit all changes
    @ echo ""
    @ echo -e "\e[32m[=================] \e[0m COMMITING ALL CHANGES"
    @ git add .
    @ read -p "Enter commit message: " message; \
    git commit -m "$$message"
    @ echo -e "\e[32m[=================] \e[0m CHANGES COMMITED"
    @ echo ""

gsts: ## Show git status
    @ echo ""
    @ echo -e "\e[32m[=================] \e[0m SHORT GIT STATUS"
    @ git status -s
    @ echo ""

gpb: ## Push local branch to remote
    @ echo ""
    @ echo -e "\e[32m[=================] \e[0m PUSHING BRANCH TO REMOTE"
    @ git push --set-upstream origin $(shell git rev-parse --abbrev-ref HEAD)
    @ echo -e "\e[32m[=================] \e[0m BRANCH PUSHED TO REMOTE"
    @ echo ""

gnb: ## Create new branch
    @ echo ""
    @ echo -e "\e[32m[=================] \e[0m CREATING NEW BRANCH"
    @ read -p "Enter branch name: " branch; \
    git checkout -b $$branch
    @ echo -e "\e[32m[=================] \e[0m BRANCH CREATED"
    @ echo ""

#------------------------------------------#
##
##          Another group
#------------------------------------------#

task-two: ## Print vars from .env file
    @echo $(somevariable)

task-three: ## Print bash variable inside
    @hello="world"
    @echo $$hello

task-four: ## Print args from command line
    @echo "run: make task-four foo bar"
    @echo $(args)

task-five: ## Run command inside
    @get_comment=$$(grep other .env)
    @echo $$get_comment


# -----------------------------   DO NOT CHANGE   -----------------------------
help:
    @grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) \
        | sed -e 's/^.*Makefile://g' \
        | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' \
        | sed -e 's/\[32m##/[33m/'
    @echo

%:      # do not change
    @:    # do not change

.DEFAULT_GOAL := help