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

clean: ## Clean up your mess
	rm -rf _build *.egg-info
	@find . -name '*.pyc' | xargs rm -rf
	@find . -name '__pycache__' | xargs rm -rf
	@for trash in *.aux *.bbl *.blg *.lof *.log *.lot *.out *.pdf *.synctex.gz *.toc ; do \
		if [ -f "$$trash" ]; then \
			rm -rf $$trash ; \
			rm frontmatter/$$trash ; \
			rm mainmatter/$$trash ; \
			rm backmatter/$$trash ; \
		fi ; \
	done

print-error:
	@:$(call check_defined, MSG, Message to print)
	@echo "$(LRED)$(MSG)$(NC)"

print-status:
	@:$(call check_defined, MSG, Message to print)
	@echo "$(LBLUE)$(MSG)$(NC)"

python: ## install virtual environment
	python3 -m venv _build
	( \
		. _build/bin/activate; \
		python3 -m pip install -rrequirements.txt; \
	)
	@$(MAKE) print-status MSG="Now type: . _build/bin/activate"
	
paper: ## generate the PDF
	latexmk -pdf -synctex=1 -shell-escape cloudlab
	bibtex cloudlab
	#makeindex cloudlab
	latexmk -pdf -synctex=1 -shell-escape cloudlab

