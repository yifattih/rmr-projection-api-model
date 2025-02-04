#-----------------------------------------------------------------------------#
##
##-----------------------------------------------------------------------------
##|                          Git Targets                                      |
##-----------------------------------------------------------------------------
##
#-----------------------------------------------------------------------------#
.PHONY: gst glog gc gcd gp gbr gbrn gbrp gbrd gbrw

gst: ## Show a git status glimpse
##  |Usage:
##  |   $ make status
##
    @ echo
    @ $(call headercan,"CHANGES")
    @ changes="$(shell git diff --color --stat HEAD | sed '$d; s/^ //')"
    @ if [ -z "$$changes" ]; then \
        $(call inform,"No file changes!"); \
    else \
        echo $$changes;
    fi
    @ echo
    @ $(call headercan,"FILES SUMMARY")
    @ $(call keyvaluecan,"Modified",$(shell git status -s | grep "^.*M " | sed "s/^.M / /g"))
    @ $(call keyvaluecan,"Staged",$(shell git status -s | grep -e "^A.*" -e "^M.*" | grep -v "^.*D" | sed -e "s/^A.* / /g" -e "s/^M.* / /g"))
    @ $(call keyvaluecan,"Deleted",$(shell git status -s | grep "^.*D " | sed "s/^.*D / /g"))
    @ $(call keyvaluecan,"Untracked",$(shell git status -s | grep "??" | sed "s/??/ /g"))
    @ echo

glog: ## Show custom git log
##  |Usage:
##  |   $ make log <int: number of entries | optional>
##
    @ echo
    @ $(call headercan,"COMMITS")
    @ # Script
    if [ -z "$(ARG1)" ]; then \
        while true; do \
            $(call prompt,"How many entries?"); \
            if ! echo "$$input" | grep -qE "^[0-9]+$$"; then \
                $(call err,"Must be an integer!!!") \
                && echo; \
            else \
                echo; \
                git --no-pager log -n "$$input" --abbrev-commit --format=format:"%s-- " \
                | sed "s/-- /\n/" \
                | sed -r \
                -e 's/([^(:]*)(\([^)]*\))(:)(.*)/$(call COMMITFORMAT)/g' \
                | tac; \
                echo; \
                exit 0; \
            fi; \
        done; \
    elif ! echo "$(ARG1)" | grep -qE '^[0-9]+$$'; then \
        $(call err,"Number of entries must be an integer!!!")
        while true; do \
            $(call prompt,"How many entries?"); \
            if ! echo "$$input" | grep -qE "^[0-9]+$$"; then \
                $(call err,"Must be an integer!!!") \
                && echo; \
            else \
                echo; \
                git --no-pager log -n "$$input" --abbrev-commit --format=format:"%s-- " \
                | sed "s/-- /\n/" \
                | sed -r \
                -e 's/([^(:]*)(\([^)]*\))(:)(.*)/$(call COMMITFORMAT)/g' \
                | tac; \
                echo; \
                exit 0; \
            fi; \
        done; \
    else \
        git --no-pager log -n "$(ARG1)" --abbrev-commit --format=format:"%s-- " \
		| sed "s/-- /\n/" \
        | sed -r \
        -e 's/([^(:]*)(\([^)]*\))(:)(.*)/$(call COMMITFORMAT)/g' \
        | tac; \
    fi;
    @ echo

gc: ## Stage files, prepare and execute cit
##  |Usage:
##  |   $ make gcommmit
##
    @ echo
    @ is_change="$(shell git status --porcelain | sed "s/.* //")"
    @ if [ -z "$$is_change" ]; then \
        $(call inform,"No files to commit!!!"); \
        echo; \
        exit 0; \
    elif [ "$$is_change" ]; then \
        $(call headercan,"FILES TO STAGE"); \
    fi
    @ git diff --color --stat HEAD | sed '$d; s/^ //' && echo
    @ while true; do \
        $(call prompt,"Enter filename (. to add all)") && filename="$$input"; \
        if [ "$$input" == "exit" ]; then \
            $(call inform,"Commit canceled!!!") \
            && echo \
            && exit 0; \
        elif [ "$$input" == "." ]; then \
            git add .; \
            $(call inform,"All files were staged") \
            && break; \
        else \
            { #try
                git add "$$input" 2>/dev/null \
                && $(call inform,"File "$$input" is staged") \
                && break; \
            } || { #catch
                    $(call err, File "$$input" do not exist!); \
            } \
            # git add "$$input" 2>/dev/null || $(call err, File "$$input" do not exist!);
        fi;
    done;
    @ echo
    @ $(call headercan,"COMMIT MESSAGE")
    @ $(call inform,"Message construction based on the AngularJS commit convention")
    @ while true; do \
        $(call prompt,"Type") && type="$$input"; \
        if [ "$$type" == "exit" ]; then \
            $(call inform,"Unstaging files"); \
            git restore --stage .; \
            $(call inform,"Commit canceled!") \
            && echo \
            && exit 0; \
        elif [ "$$type" == "" ]; then \
            $(call err,"The Type field cannot be empty"); \
        else \
            $(call inform,"Type field stored"); \
            $(call keyvaluecan,"Type","$$type") \
            && break; \
        fi;
    done;
    @ echo
    @ while true; do \
        $(call prompt,"Scope") && scope="$$input"; \
        if [ "$$scope" == "exit" ]; then \
            $(call inform,"Unstaging files"); \
            git restore --stage .; \
            $(call inform,"Commit canceled!") \
            && echo \
            && exit 0; \
        elif [ "$$scope" == "" ]; then \
            $(call err,"The Scope field cannot be empty"); \
        else \
            $(call inform,"Scope field stored"); \
            $(call keyvaluecan,"Scope","$$scope") \
            && break; \
        fi;
    done;
    @ echo
    @ while true; do \
        $(call prompt,"Imperative Description") && description="$$input"; \
        if [ "$$description" == "exit" ]; then \
            $(call inform,"Unstaging files"); \
            git restore --stage .; \
            $(call inform,"Commit canceled!") \
            && echo \
            && exit 0; \
        elif [ "$$description" == "" ]; then \
            $(call err,"The Description field cannot be empty"); \
        else \
            $(call inform,"Description field stored"); \
            $(call keyvaluecan,"Description","$$scope") \
            && break; \
        fi;
    done;
    @ echo
    @ $(call headercan,"COMMIT SUMMARY")
    @ message=""$$type"("$$scope"): "$$description"" 
    @ $(call keyvaluecan,"Filename")
    @ echo "$$filename"
    @ $(call keyvaluecan,"Message")
    @ echo -e "$$message"
    @ echo
    @ git commit -m "$$message"
    @ $(call inform,"Done!")
    @ echo

gcd: ## Delete last commit message
##  |Usage:
##  |   $ make gcommd
##
    @ echo
    @ $(call headercan, "DELETE LAST COMMIT")
    @ hash="$(shell git rev-parse --short HEAD)"
    @ $(call keyvaluecan,"Hash",$$hash)
    @ git reset --soft HEAD~1
    @ echo

gbr: ## Prints Git branches
    @ echo
    @ CURRENT+="$(shell git branch --show-current)"
    @ LOCAL+="$(shell git branch --format="%(refname:short)")"
    @ REMOTE+="$(shell git branch -r --format="%(refname:short)" | sed "s/origin\///g")"
    @ $(call headercan,"BRANCHES")
    @ $(call keyvaluecan,"Current",$$CURRENT)
    @ $(call keyvaluecan,"Local",$$LOCAL)
    @ $(call keyvaluecan,"Remote",$$REMOTE)