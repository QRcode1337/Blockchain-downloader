## 
## _|          _|  _|        _|_|_|_|  _|_|_|_|  _|_|_|    _|_|_|
## _|          _|  _|        _|        _|        _|    _|  _|    _|
## _|    _|    _|  _|        _|_|_|    _|_|_|    _|_|_|    _|    _|
##   _|  _|  _|    _|        _|        _|        _|    _|  _|    _|
##     _|  _|      _|_|_|_|  _|        _|        _|_|_|    _|_|_|
##

## Variables here can be set on the commandline or in Makefile-local

VENV_NAME	=env
VENV_PYTHON	=python
VENV_CMD_OPTS	=

-include Makefile-local

## Variables here cannot be reset by Makefile-local only by the commandline
PACKAGE		=wlffbd

VENV_CMD	=virtualenv $(VENV_CMD_OPTS)
VENV_ACTIVATE	=env | grep VIRTUAL_ENV > /dev/null || . $(VENV_NAME)/bin/activate
VENV_PIP	=$(VENV_NAME)/bin/pip

## Entry point, default target
title: banner
	@echo '        Wiki Leaks Freedom Force: Blockchain Downloader'

banner:
	@cat Makefile | head -7 | sed -e 's/^## //'

## Standard target for cleaning up any intermediate files generated by the tools
clean:
	rm -f file fileo headerfiles.txt
	rm -f file.txt filein.txt fileorig.txt File.txt Filein.txt Fileorig.txt hashindex.txt
	find . -type f -name '*~' -delete

## Initialize the virtual environment
init:
	[ -e $(VENV_NAME) ] || $(VENV_CMD) -p $(VENV_PYTHON) $(VENV_NAME)
	$(VENV_PIP) install -r requirements.txt

## Initialize the virtual environment for developers
init-dev:
	[ -e $(VENV_NAME) ] || $(VENV_CMD) -p $(VENV_PYTHON) $(VENV_NAME)
	$(VENV_PIP) install -r requirements-dev.txt
	$(VENV_PIP) install -e .

## Lint the code with pyflakes
lint:
	$(VENV_ACTIVATE) && py.test --flakes -m flakes $(PACKAGE)

## Unit test the code
unit:
	$(VENV_ACTIVATE) && py.test tests

## Unit test with code coverage
coverage:
	$(VENV_ACTIVATE) && py.test --cov-report term-missing --cov=$(PACKAGE) tests

## Audit the code with linting and code coverage
audit: lint coverage
	@echo Completed audit

## Create installable package
wheel:
	$(VENV_ACTIVATE) && python setup.py bdist_wheel

## Some example invocations for integration testing
integrate:
	python blockchain_downloader.py `head -1 data/transactions/cablegate-transactions.txt`
	python blockchain_downloader.py `head -1 data/addresses/wikileaks-addresses.txt`
