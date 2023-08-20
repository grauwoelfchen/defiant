DATABASE_URL := $(if $(ENV),"$$$(shell echo "$(ENV)" | \
								tr '[:lower:]' '[:upper:]')_DATABASE_URL","$${DATABASE_URL:-}")
MIGRATION_NAME ?=

ENV ?= development

setup:
	@which diesel >/dev/null 2>&1 || cargo install \
		diesel_cli --no-default-features --features postgres --force
	@whereis diesel
.PHONY: setup

# MIGRATION_NAME=xxx make schema:migration:create
schema\:migration\:create: # Generate a new migration files (require: MIGRATION_NAME env var)
	@if [ -z "$(MIGRATION_NAME)" ]; then \
		echo "MIGRATION_NAME is not set" >&2; \
		exit 1; \
	fi
	@if [ "$(ENV)" != "development" ]; then \
		echo "ENV should not be $(ENV) (unset)" >&2; \
		exit 1; \
	fi
	@set -uo pipefail; \
	if [ -f "$$(pwd)/.env" ]; then \
		source $$(pwd)/.env && \
		export $$(cut -d "=" -f 1 $$(pwd)/.env | sed -e '/^\(\#\|$$\)/d'); \
	fi; \
	export DATABASE_URL="$(DATABASE_URL)"; \
	if [ -z "$${DATABASE_URL}" ]; then \
		echo "DATABASE_URL is not set" >&2; \
		exit 1; \
	fi; \
	diesel setup; \
	diesel migration generate \
		--version $$(date +%Y%m%d%H%M%S) \
		$(MIGRATION_NAME)
.PHONY: schema\:migration\:create

schema\:migration\:commit: # Run all migrations
	@set -uo pipefail; \
	if [ -f "$$(pwd)/.env" ]; then \
		source $$(pwd)/.env && \
		export $$(cut -d "=" -f 1 $$(pwd)/.env | sed -e '/^\(\#\|$$\)/d'); \
	fi; \
	export DATABASE_URL="$(DATABASE_URL)"; \
	if [ -z "$${DATABASE_URL}" ]; then \
		echo "DATABASE_URL is not set" >&2; \
		exit 1; \
	fi; \
	diesel setup; \
	diesel migration run
.PHONY: schema\:migration\:commit

schema\:migration\:revert: # Rollback the latest migration
	@set -uo pipefail; \
	if [ -f "$$(pwd)/.env" ]; then \
		source $$(pwd)/.env && \
		export $$(cut -d "=" -f 1 $$(pwd)/.env | sed -e '/^\(\#\|$$\)/d'); \
	fi; \
	export DATABASE_URL="$(DATABASE_URL)"; \
	if [ -z "$${DATABASE_URL}" ]; then \
		echo "DATABASE_URL is not set" >&2; \
		exit 1; \
	fi; \
	diesel setup; \
	diesel migration revert
.PHONY: schema\:migration\:revert

schema\:migration\:status: # List all migrations
	@set -uo pipefail; \
	if [ -f "$$(pwd)/.env" ]; then \
		source $$(pwd)/.env && \
		export $$(cut -d "=" -f 1 $$(pwd)/.env | sed -e '/^\(\#\|$$\)/d'); \
	fi; \
	export DATABASE_URL="$(DATABASE_URL)"; \
	if [ -z "$${DATABASE_URL}" ]; then \
		echo "DATABASE_URL is not set" >&2; \
		exit 1; \
	fi; \
	diesel setup; \
	diesel migration list
.PHONY: schema\:migration\:status

build: # Build the application with debug mode
	elm make src/Defiant.elm --debug --output dst/script.js
.PHONY: build

build\:release: # Build the application with release mode (--optimize)
	elm make src/Defiant.elm --optimize --output dst/script.js
.PHONY: build\:release

help: # Display this message
	@set -uo pipefail; \
	grep --extended-regexp '^[0-9a-z\:\\\%]+: ' \
		$(firstword $(MAKEFILE_LIST)) | \
		grep --extended-regexp ' # ' | \
		sed --expression='s/\([a-z0-9\-\:\ ]*\): \([a-z0-9\-\:\ ]*\) #/\1: #/g' | \
		tr --delete \\\\ | \
		awk 'BEGIN {FS = ": # "}; \
			{printf "\033[38;05;68m%-24s\033[0m %s\n", $$1, $$2}' | \
		sort
.PHONY: help

.DEFAULT_GOAL = build:release
default: build\:release
