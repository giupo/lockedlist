# Makefile for generating R packages.
# 2011 Andrew Redd
# 2014 Giuseppe Acito

PKG_VERSION=$(shell grep -i ^version DESCRIPTION | cut -d : -d \  -f 2)
PKG_NAME=$(shell grep -i ^package DESCRIPTION | cut -d : -d \  -f 2)

R_EXEC := R
R_SCRIPT := Rscript
R_FILES := $(wildcard R/*.[R|r])
SRC_FILES := $(wildcard src/*) $(addprefix src/, $(COPY_SRC))
PKG_FILES := DESCRIPTION NAMESPACE $(R_FILES) $(SRC_FILES)
PKG_FILE := $(PKG_NAME)_$(PKG_VERSION).tar.gz

.PHONY: list coverage changelog NEWS.md coverage

tarball: $(PKG_FILE)

$(PKG_FILE): $(PKG_FILES)
	$(R_EXEC) --vanilla CMD build .

build: tarball

check: ${PKG_FILE}
	$(R_EXEC) CMD check ${PKG_FILE}

install: $(PKG_FILE)
	$(R_EXEC) --vanilla CMD INSTALL $(PKG_FILE)

NAMESPACE: $(R_FILES)
	$(R_SCRIPT) -e "devtools::document()"

clean:
	-rm -f $(PKG_FILE)
	-rm -r -f $(PKG_NAME).Rcheck
	-rm -r -f man/*
	-rm -f src/*.so src/*.o

list:
	@echo "R files:"
	@echo $(R_FILES)
	@echo "Source files:"
	@echo $(SRC_FILES)

coverage:
	$(R_SCRIPT) -e 'covr::package_coverage(path=".")'

codecov:
	$(R_SCRIPT) -e 'covr::codecov(path=".")'

test:
	$(R_SCRIPT) -e 'devtools::test()'

NEWS.md:
	gitchangelog > NEWS.md

changelog: NEWS.md
