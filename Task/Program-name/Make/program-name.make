NAME=$(CURDIR)/$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))

all:
	@echo $(NAME)
