# Used for colorizing output of echo messages
BLUE := "\\033[1\;36m"
LBLUE := "\\033[1\;34m"
LRED := "\\033[1\;31m"
YELLOW := "\\033[1\;33m"
NC := "\\033[0m" # No color/default

define PRINT_HELP_PYSCRIPT
import re, sys

for line in sys.stdin:
  match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
  if match:
    target, help = match.groups()
    print("%-20s %s" % (target, help))
endef

export PRINT_HELP_PYSCRIPT

help:
	@python3 -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)

build: ## make the docker image
	docker build -t frank378:mlbot \
		--build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') . | tee .buildlog

clean: ## clean up your mess
	rm -rf _build *.egg-info

print-error:
	@:$(call check_defined, MSG, Message to print)
	@echo -e "$(LRED)$(MSG)$(NC)"

print-status:
	@:$(call check_defined, MSG, Message to print)
	@echo -e "$(LBLUE)$(MSG)$(NC)"

python: ## install virtual environment
	python3 -m venv _build
	. _build/bin/activate
	python3 -m pip install -rrequirements.txt

test: ## run all test cases
	@if [ ! -d "/nix" ]; then $(MAKE) print-error MSG="You don't have nix installed." && exit 1; fi
	@$(MAKE) print-status MSG="Running test cases"
	@nix-shell --run "tox -e py38"

.PHONY: paper
paper: ## generate the PDF
	@if [ ! -d /nix ]; then  echo "***> Where is your nix installation? <***" && exit 1; fi
	latexmk -pdf -synctex=1 -shell-escape main
	bibtex main
	#makeindex main
	latexmk -pdf -synctex=1 -shell-escape main

