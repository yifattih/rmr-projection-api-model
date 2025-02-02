## Function to log messages
define log_keyvalue
    echo -e "$(strip $(Yellow)"$(1)")$(strip $(White):)$(strip $(Blue)"$(2)"$(Color_Off))"
endef

define log_prompt
	echo -e -n "$(strip $(Yellow) "$(1)":$(Color_Off)) " \
	&& read input
endef

define inform
	@ echo -e "$(strip $(White)"$(1)"$(Color_Off))"
endef

define log
    echo -e "$(strip $(BIGreen)"$(1)"$(Color_Off))"
	echo -e "$(strip $(BIWhite)----------------------------------------------$(Color_Off))"
endef

define log_warn
	@echo -e "$(YELLOW)>>> "$(1)" <<<$(NC)"
endef

define log_error
	echo -e "$(strip $(Red)ERROR:$(Yellow)"$(1)"$(Color_Off))"
endef