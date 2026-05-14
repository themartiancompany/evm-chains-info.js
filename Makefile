# SPDX-License-Identifier: AGPL-3.0

#    -----------------------------------------------------
#    Copyright © 2024, 2025, 2026  Pellegrino Prevete
#
#    All rights reserved
#    -----------------------------------------------------
#
#    This program is free software: you can redistribute
#    it and/or modify it under the terms of the
#    GNU Affero General Public License as published by
#    the Free Software Foundation, either version 3 of
#    the License, or (at your option) any later version.
#
#    This program is distributed in the hope that it
#    will be useful, but WITHOUT ANY WARRANTY;
#    without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#    See the GNU Affero General Public License for
#    more details.
#
#    You should have received a copy of the
#    GNU Affero General Public License
#    along with this program.
#    If not, see <https://www.gnu.org/licenses/>.

SHELL=bash
PREFIX ?= /usr/local
_PROJECT_NPM=evm-chains-info
_PROJECT=$(_PROJECT_NPM).js
_NAMESPACE=themartiancompany
DOC_DIR=$(DESTDIR)$(PREFIX)/share/doc/$(_PROJECT)
USR_DIR=$(DESTDIR)$(PREFIX)
BIN_DIR=$(DESTDIR)$(PREFIX)/bin
LIB_DIR=$(DESTDIR)$(PREFIX)/lib/$(_PROJECT)
MAN_DIR?=$(DESTDIR)$(PREFIX)/share/man
NODE_DIR=$(PREFIX)/lib/node_modules/$(_PROJECT)
BUILD_NPM_DIR=build

_INSTALL_FILE=\
  install \
    -vDm644
_INSTALL_EXE=\
  install \
    -vDm755
_INSTALL_DIR=\
  install \
    -vdm755

DOC_FILES=\
  $(wildcard \
      *.rst) \
  $(wildcard \
      *.md)
NPM_FILES=\
  "README.md" \
  "COPYING" \
  "AUTHORS.rst" \
  "evm-chains-info" \
  "eslint.config.mjs" \
  "fs-worker.webpack.config.cjs" \
  "libevm-chains-info" \
  "libevm-chains-info.webpack.config.cjs" \
  "package.json" \
  "webpack.config.cjs"

all: build-man build-npm

check: eslint

eslint:

	npm \
	  install \
	  --save-dev \
	  "."; \
	npx \
	  eslint \
	    "."

clean:

	cd \
	  "build"; \
	rm \
	  -rf \
	  "node_modules"

install: install-npm install-scripts install-doc install-examples install-man

install-scripts:

	$(_INSTALL_DIR) \
	  "$(LIB_DIR)"
	for _file in $(NPM_FILES); do
	  $(_INSTALL_FILE) \
	    "$${_file}" \
	    "$(LIB_DIR)/nodejs/$${_file}"; \
	done
	ln \
	  -s \
	  "$(PREFIX)/lib/$(_PROJECT_NPM)/nodejs/lib$(_PROJECT_NPM)" \
	  "$(LIB_DIR)/$(_PROJECT_NPM)-js" || \
	true

build-man:

	git \
	  submodule \
	    update \
	    --init \
	      "man" || \
	true; \
	_tag="$$( \
	  git \
	    tag | \
	    sort \
	      -V | \
              head \
	        -n \
	          1)"; \
	mkdir \
	  -p \
	  "build/man"; \
	cp \
	  "man/variables.rst" \
	  "build/man"; \
	cat \
	  "man/$(_PROJECT_NPM).1.rst" | \
	  sed \
	    "s/$(_PROJECT_NPM)/$(_PROJECT)/g" > \
	    "build/man/$(_PROJECT).1.rst"; \
	sed \
	  "s/insert.version.here/$${_tag}/" \
	  -i \
	  "build/man/variables.rst"; \
	rst2man \
	  "build/man/$(_PROJECT).1.rst" \
	  "build/man/$(_PROJECT).1"; \
	rm \
	  "build/man/$(_PROJECT).1.rst"; \
	rm \
	  "build/man/variables.rst"

build-npm:

	make \
	  build-man
	cp \
	  -r \
	  $(NPM_FILES) \
	  "build"; \
	cd \
	  "build"; \
	_version="$$( \
	  npm \
	    view \
	      "$${PWD}" \
	      "version")"; \
	npm \
	  install \
	  "."; \
	npm \
	  run \
	    "build"; \
	npm \
	  install \
	  "."; \
	chmod \
	  +x \
	  "evm-chains-info"; \
	npm \
	  pack; \
	chmod \
	  +x \
	  "evm-chains-info"; \
	mv \
	  "$(_PROJECT_NPM)-$${_version}.tgz" \
	  ".."

install-npm:

	_npm_opts=( \
	  -g \
	  --prefix \
	    '$(USR_DIR)' \
	); \
	_version="$$( \
	  npm \
	    view \
	      "$${PWD}" \
	      "version")"; \
	npm \
	  install \
	    "$${_npm_opts[@]}" \
	    "$(_PROJECT_NPM)-$${_version}.tgz"; \
	$(_INSTALL_DIR) \
	  "$(DESTDIR)$(PREFIX)/lib/$(_PROJECT_NPM)"; \
	ln \
	  -s \
	  "$(NODE_DIR)" \
	  "$(DESTDIR)$(PREFIX)/lib/$(_PROJECT_NPM)/nodejs" || \
	true
	ln \
	  -s \
	  "$(NODE_DIR)/lib$(_PROJECT_NPM)" \
	  "$(LIB_DIR)/$(_PROJECT_NPM)-js" || \
	true

publish-npm:

	cd \
	  "build"; \
	npm \
	  publish \
	  --access \
	    "public"

install-doc:

	$(_INSTALL_FILE) \
	  $(DOC_FILES) \
	  -t \
	  $(DOC_DIR)

install-man:

	$(_INSTALL_DIR) \
	  "$(MAN_DIR)/man1"
	$(_INSTALL_FILE) \
	  "build/man/$(_PROJECT).1" \
	  "$(MAN_DIR)/man1/$(_PROJECT).1"

.PHONY: check build-man build-npm clean install install-doc install-man install-npm install-scripts shellcheck
