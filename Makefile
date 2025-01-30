## ============================================================================
##            Source: https://github.com/thevops/makefile-automation
##            Additions by: @yifattih
##            Description: Makefile Targets for common taks automation
## ============================================================================

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

LOGLNES ?= 5

#-----------------------------------------------------------------------------#
##
##-----------------------------------------------------------------------------
##|                          Git Targets                                      |
##-----------------------------------------------------------------------------
##
#-----------------------------------------------------------------------------#

commit: ## Commit all changes
##  |Usage:
##  |   $ make commit
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

commit-delete: ## Delete last commit message
##  |Usage:
##  |   $ make commit-delete
    @ echo
    @ echo -e "\e[32m[=================] \e[0m DELETING LAST COMMIT MESSAGE \e[32m[=================] \e[0m"
    @ git reset --soft HEAD~1
    @ echo -e "\e[32m[=================] \e[0m                              \e[32m[=================] \e[0m"
    @ echo

commit-file: ## Commit specific file
##  |Usages:
##  |   $ make commit-file
##  |   $ make commit-file file=<file_name>
##  |   $ make commit-file message=<commit_message>
##  |   $ make commit-file file=<file_name> message=<commit_message>
    @ echo
    @ echo -e "\e[32m[=================] \e[0m COMMITING SPECIFIC FILE \e[32m[=================] \e[0m"
    @ if [ -z "$(file)" ]; then make -s status-short && read -p "Enter file name: " file && git add $$file; else git add $$file; fi
    @ if [ -z "$(message)" ]; then read -p "Enter commit message: " message && git commit -m "$$message"; else git commit -m "$$message"; fi
    @ echo -e "\e[32m[=================] \e[0m                         \e[32m[=================] \e[0m"
    @ echo

status: ## Show custom git status glimpse
##  |Usage:
##  |   $ make status
    @ echo
    @ echo -e "\e[32m[=================] \e[0m GIT SHORT STATUS \e[32m[=================] \e[0m"
    @ git diff --color --stat=$(($(tput cols) - 3)) HEAD | sed '$d; s/^ //'
    @ echo
    @ echo "---------- Summary ----------"
    @ echo "Modified:   $(shell git status -s | grep "^.*M" | wc -l)"
    @ echo "Staged:     $(shell git status -s | grep -e "^A.*" -e "^M.*" | grep -v "^.*D" | wc -l)"
    @ echo "Deleted:    $(shell git status -s | grep "^.*D" | wc -l)"
    @ echo "Untracked:  $(shell git status -s | grep "??" | wc -l)"
    # git status -s | grep " M" | wc -l
    # git status -s | grep "^M" | wc -l
    @ echo -e "\e[32m[=================] \e[0m                  \e[32m[=================] \e[0m"
    @ echo

branch: ## Show current branches
##  |Usage:
##  |   $ make branch
    @ echo
    @ echo -e "\e[32m[=================] \e[0m GIT BRANCHES \e[32m[=================] \e[0m"
    @ echo "Current Branch"
    @ echo "--------------------"
    @ git branch | grep "\*" | sed 's/\*//g' | sed 's/ //g'
    @ echo
    @ echo "Local Branches"
    @ echo "--------------------"
    @ git branch | sed 's/\*//g' | sed 's/ //g'
    @ echo
    @ echo "Remote Branches"
    @ echo "--------------------"
    @ git branch -a | grep "remotes" | sed 's/\// /g' | sed 's/.* //'
    @ echo -e "\e[32m[=================] \e[0m              \e[32m[=================] \e[0m"
    @ echo

branch-push: ## Push current local branch to remote
##  |Usage:
##  |   $ make branch-push
    @ echo
    @ echo -e "\e[32m[=================] \e[0m PUSHING BRANCH TO REMOTE \e[32m[=================] \e[0m"
    @ git push --set-upstream origin $(shell git rev-parse --abbrev-ref HEAD)
    @ echo -e "\e[32m[=================] \e[0m                          \e[32m[=================] \e[0m"
    @ echo

branch-new: ## Create new local branch
##  |Usages:
##  |   $ make branch-new
##  |   $ make branch-new name=<branch_name>
    @ echo
    @ echo -e "\e[32m[=================] \e[0m CREATING NEW BRANCH \e[32m[=================] \e[0m"
    @ if [ -z "$(name)" ]; then read -p "Enter branch name: " branch && git checkout -b $$branch; else git checkout -b $$name; fi
    @ echo -e "\e[32m[=================] \e[0m                     \e[32m[=================] \e[0m"
    @ echo

log: ## Show custom git log
##  |Usages:
##  |   $ make log
##  |   $ make log LOGLNES=<number of commits>
    @ echo
    @ echo -e "\e[32m[=================] \e[0mGIT LOG: \e[33mLAST $(LOGLNES) COMMITS \e[32m[=================] \e[0m"
    @ git --no-pager log -n $(LOGLNES) --graph --color --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''               %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all | tac -b --separator=" * |"
    # @ git log --pretty=format:"%h - %an, %ar : %s"
    @ echo
    @ echo -e "\e[32m[=================] \e[0m                          \e[32m[=================] \e[0m"
    @ echo

# #-----------------------------------------------------------------------------#
# ##
# ##-----------------------------------------------------------------------------
# ##|                          Another Targets                                  |
# ##-----------------------------------------------------------------------------
# ##
# #-----------------------------------------------------------------------------#

# task-two: ## Print vars from .env file
#     @echo $(somevariable)

# task-three: ## Print bash variable inside
#     @hello="world"
#     @echo $$hello

# task-four: ## Print args from command line
#     @echo "run: make task-four foo bar"
#     @echo $(args)

# task-five: ## Run command inside
#     @get_comment=$$(grep other .env)
#     @echo $$get_comment


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