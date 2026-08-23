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

_NPM ?= false
SHELL ?= bash
PREFIX ?= /usr/local
_PROJECT_NPM=evm-chains-info
_PROJECT=$(_PROJECT_NPM).js
_NAMESPACE=themartiancompany
DOC_DIR=$(DESTDIR)$(PREFIX)/share/doc/$(_PROJECT)
USR_DIR=$(DESTDIR)$(PREFIX)
BIN_DIR=$(DESTDIR)$(PREFIX)/bin
LIB_DIR=$(DESTDIR)$(PREFIX)/lib/$(_PROJECT_NPM)
MAN_DIR?=$(DESTDIR)$(PREFIX)/share/man
NODE_DIR=$(PREFIX)/lib/node_modules/$(_PROJECT_NPM)
BUILD_NPM_DIR=build

_MAKE_LINK=\
  ln \
    -s
_MAKE_EXE=\
  chmod \
    755
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
  "dist" \
  "evm-chains-info" \
  "eslint.config.mjs" \
  "fs-worker.webpack.config.cjs" \
  "libevm-chains-info" \
  "libevm-chains-info.webpack.config.cjs" \
  "package.json" \
  "webpack.config.cjs"

all: build 

build-man:

	git \
	  submodule \
	    update \
	    --init \
	      "man" || \
	true; \
	mkdir \
	  -p \
	  "build/man"; \
	cp \
	  -v \
	  "man/variables.rst" \
	  "build/man"; \
	ls \
	  -lsh \
	  "build/man"; \
	cat \
	  "man/$(_PROJECT_NPM).1.rst" | \
	  sed \
	    "s/$(_PROJECT_NPM)/$(_PROJECT)/g" > \
	    "build/man/$(_PROJECT).1.rst"; \
	_version="$$( \
	  npm \
	    view \
	      "$${PWD}" \
	      "version")"; \
	sed \
	  "s/insert.version.here/$${_version}/" \
	  -i \
	  "build/man/variables.rst"; \
	sed \
	  "s/insert.version.here/$${_tag}/" \
	  -i \
	  "build/man/variables.rst"; \
	rst2man \
	  "build/man/$(_PROJECT).1.rst" \
	  "build/man/$(_PROJECT).1"; \
	rm \
	  "build/man/$(_PROJECT).1.rst";
	# rm \
	#   "build/man/variables.rst"

build-npm:

	make \
	  build-man
	for _file in $(NPM_FILES); do \
	  if [[ -d "$${_file}" ]]; then \
	    mkdir \
	     -p \
	     "build/$${_file}"; \
	    cp \
	      -r \
	      "$${_file}/"* \
	      "build/$${_file}"; \
	  elif [[ -e "$${_file}" ]]; then \
	    cp \
	      -r \
	      "$${_file}" \
	      "build"; \
	    $(_INSTALL_FILE) \
	      "$${_file}" \
	      "build/$${_file}"; \
	  fi; \
	done;
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

build-webpack:

	cp \
	  -r \
	  "$(_PROJECT)" \
	  "dist" \
	  "lib$(_PROJECT)" \
	  "webpack.config.cjs" \
	  "build"
	_webpack=( \
	  "$$(command \
	        -v \
	        "webpack")"; \
	if [[ "${_webpack}" == "" ]]; then \
	  _webpack=(
	    npx
	      webpack); \
	fi; \
	cd \
	  "build"; \
	if [[ ! -e "fs-worker.js" ]]; then \
          "${_webpack[@]}" \
	    --mode \
	      'production' \
	    --config \
	    'fs-worker.webpack.config.cjs' \
	    --stats-error-details; \
	fi; \
	cp \
	  'fs-worker.js' \
	  'dist/$(_PROJECT)/fs-worker.js'; \
	cp \
	  'fs-worker.js' \
	  'dist/lib$(_PROJECT)/fs-worker.js'; \
	if [[ ! -e "$(_PROJECT).js" ]]; then \
          "${_webpack[@]}" \
	    --mode \
	      'production' \
	    --config \
	      'webpack.config.cjs' \
	    --stats-error-details; \
	fi; \
	cp \
	  "$(_PROJECT).js" \
	  "dist/$(_PROJECT)/$(_PROJECT).js"
	if [[ ! -e "lib$(_PROJECT).js" ]]; then \
          "${_webpack[@]}" \
	    --mode \
	      'production' \
	    --config \
	      'webpack.config.cjs' \
	    --stats-error-details; \
	fi; \
	cp \
	  "lib$(_PROJECT).js" \
	  "dist/lib$(_PROJECT)/lib$(_PROJECT).js"

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

	if [[ "$(_NPM)" == "false" ]]; then \
	  $(_INSTALL_DIR) \
	    "$(LIB_DIR)/nodejs"; \
	  cp \
	    -r \
	    $$(printf \
	         "$${PWD}/%s " \
	         $$(cat \
	              "$${PWD}/package.json" | \
	              jq \
	                --raw-output \
	                '.files[]')) \
	    "$(LIB_DIR)/nodejs"; \
	  $(_MAKE_EXE) \
	    "$(LIB_DIR)/nodejs/$(_PROJECT_NPM)"; \
	  rm \
	    -vf \
	    "$(BIN_DIR)/$(_PROJECT)"; \
	  if [[ ! -s "$(BIN_DIR)/$(_PROJECT)" ]]; then \
	    $(_MAKE_LINK) \
	      "$(PREFIX)/lib/$(_PROJECT_NPM)/nodejs/$(_PROJECT_NPM)" \
	      "$(BIN_DIR)/$(_PROJECT)"; \
	  fi; \
	  if [[ ! -s "$(BIN_DIR)/$(_PROJECT_NPM)" && \
	        ! -e "$(BIN_DIR)/$(_PROJECT_NPM)" ]]; then \
	    $(_MAKE_LINK) \
	      "$(PREFIX)/lib/$(_PROJECT_NPM)/nodejs/$(_PROJECT_NPM)" \
	      "$(BIN_DIR)/$(_PROJECT_NPM)"; \
	  fi; \
	  rm \
	    "$(LIB_DIR)/node_modules" || \
	    true; \
	  if [[ ! -s "$(LIB_DIR)/node_modules" ]]; then \
	    $(_MAKE_LINK) \
	      "$(PREFIX)/lib/node_modules" \
	      "$(LIB_DIR)/nodejs/node_modules"; \
	  fi; \
	  rm \
	    -rf \
	    "$(DESTDIR)$(PREFIX)/lib/node_modules/$(_PROJECT)" \
	    "$(DESTDIR)$(PREFIX)/lib/node_modules/$(_PROJECT_NPM)"; \
	  if [[ ! -s "$(DESTDIR)$(PREFIX)/lib/node_modules/$(_PROJECT)" ]]; then \
	    $(_MAKE_LINK) \
	      "$(PREFIX)/lib/$(_PROJECT_NPM)/nodejs" \
	      "$(DESTDIR)$(PREFIX)/lib/node_modules/$(_PROJECT)"; \
	  fi; \
	  if [[ ! -s "$(DESTDIR)$(PREFIX)/lib/node_modules/$(_PROJECT_NPM)" ]]; then \
	    $(_MAKE_LINK) \
	      "$(PREFIX)/lib/$(_PROJECT_NPM)/nodejs" \
	      "$(DESTDIR)$(PREFIX)/lib/node_modules/$(_PROJECT_NPM)" || \
	      true; \
	  fi; \
	elif [[ "$(_NPM)" == "true" ]]; then \
	  make \
	    install-npm; \
	  $(_MAKE_LINK) \
	    "$(PREFIX)/lib/node_modules/$(_PROJECT_NPM)" \
	    "$(LIB_DIR)/nodejs" || \
	  true; \
	fi;

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

uninstall-man:

	rm  \
	  -vrf \
	  "$(MAN_DIR)/man1/$(_PROJECT).1"

uninstall-scripts:

	rm  \
	  -vrf \
	  "$(LIB_DIR)/nodejs" \
	  "$(LIB_DIR)/$(_PROJECT_NPM)" \
	  "$(DESTDIR)$(PREFIX)/lib/$(_PROJECT)" \
	  "$(DESTDIR)$(PREFIX)/lib/node_modules/$(_PROJECT_NPM)" \
	  "$(DESTDIR)$(PREFIX)/lib/node_modules/$(_PROJECT)"

.PHONY: check build-man build-npm clean install install-doc install-man install-npm install-scripts shellcheck uninstall-scripts
