rec_wildcard=$(foreach d, $(wildcard $1*), $(call rec_wildcard,$d/,$2) $(filter $(subst *,%,$2),$d))

MIX ?= mix

MIX_ENV = dev

BIN   = potion
SRCS  = $(call rec_wildcard, lib/, *.ex) mix.exs
BEAMS = $(call rec_wildcard, _build/$(MIX_ENV)/, *.beam *.app *.elixir *.lock)
TESTS = $(call rec_wildcard, test/, *.exs)
SPECS = $(call rec_wildcard, spec/, *.exs)

all: $(BIN) doc

test: $(TESTS) $(SPECS) $(BEAMS) $(SRCS)
	@echo "`tput setaf 7; tput setab 1`Running tests`tput sgr 0`"
	@MIX_ENV=$(MIX_ENV) $(MIX) test
	@echo "`tput setaf 7; tput setab 1`Running specs`tput sgr 0`"
	@MIX_ENV=$(MIX_ENV) $(MIX) spec
.PHONY: test

clean:
	@echo "`tput setaf 7; tput setab 1`Cleaning up binary`tput sgr 0`"
	@rm -rf $(BIN)
	@echo "`tput setaf 7; tput setab 1`Cleaning up beam-files`tput sgr 0`"
	@MIX_ENV=$(MIX_ENV) $(MIX) clean
	@rm -rf _build
	@echo "`tput setaf 7; tput setab 1`Cleaning up documentation`tput sgr 0`"
	@rm -rf doc
.PHONY: clean

rebuild: clean all

doc:
	@echo "`tput setaf 7; tput setab 1`Building documentation`tput sgr 0`"
	@MIX_ENV=$(MIX_ENV) $(MIX) docs
.PHONY: doc

run: $(BIN)
	@echo "`tput setaf 7; tput setab 1`Running 'potion'`tput sgr 0`"
	@./$(BIN)
.PHONY: run

%.beam:
	@echo "`tput setaf 7; tput setab 1`Compiling application`tput sgr 0`"
	@MIX_ENV=$(MIX_ENV) $(MIX) compile

%.app:
	@echo "`tput setaf 7; tput setab 1`Compiling application`tput sgr 0`"
	@MIX_ENV=$(MIX_ENV) $(MIX) compile

$(BIN): $(BEAMS) $(SRCS)
	@echo "`tput setaf 7; tput setab 1`Compiling 'potion'-executable`tput sgr 0`"
	@MIX_ENV=$(MIX_ENV) $(MIX) escript.build