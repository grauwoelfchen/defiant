PACKAGE = defiant

# vet
vet\:check: # Check error [synonym: check]
	@cargo check --workspace --verbose
.PHONY: vet\:check

check: vet\:check
.PHONY: check

vet\:format: # Show format diff [synonym: vet:fmt, format, fmt]
	@cargo fmt --all -- --check
.PHONY: vet\:format

vet\:fmt: vet\:format
.PHONY: vet\:fmt

format: vet\:format
.PHONY: format

fmt: vet\:format
.PHONY: fmt

vet\:lint: # Show suggestions relates to hygiene [synonym: lint]
	@cargo clippy --all-targets
.PHONY: vet\:lint

lint: vet\:lint
.PHONY: lint

vet\:all: check fmt lint # Run all vet targets [synonym: vet]
.PHONY: vet\:all

vet: vet\:all
.PHONY: vet

# test
test\:unit\:lib: # Run only unit tests for lib package
	@cargo test --package $(PACKAGE) --lib -- --nocapture
.PHONY: test\:unit\:lib

test\:unit\:cli: # Run only unit tests for a binary in -cli package
	@cargo test --package $(PACKAGE)-cli --bin -- --nocapture
.PHONY: test\:unit\:lib

test\:unit\:web: # Run only unit tests for binaries in -web package
	@cargo test --package $(PACKAGE)-web --bins -- --nocapture
.PHONY: test\:unit\:web

test\:unit: # Run only unit tests for all packages
	@cargo test --lib --bins -- --nocapture
.PHONY: test\:unit

test\:integration: # Run only integration tests for all packages
	@cargo test --test integration -- --nocapture
.PHONY: test\:integration

test\:doc: # Run only doc tests
	@cargo test --doc
.PHONY: test\:doc

test\:all: test\:doc # Run all tests [synonym: test]
	@cargo test --all -- --nocapture
.PHONY: test\:all

test: test\:all
.PHONY: test

# build
build\:debug\:lib: # Build only lib package with debug mode
	cargo build --package $(PACKAGE) --lib
.PHONY: build\:debug\:lib

build\:debug\:cli: # Build only -cli package with debug mode
	cargo build --package $(PACKAGE)-cli --bins
.PHONY: build\:debug\:cli

build\:debug\:web: # Build only -web package with debug mode
	cargo build --package $(PACKAGE)-web --bins
.PHONY: build\:debug\:web

build\:release\:lib: # Build only lib package with release mode
	cargo build --package $(PACKAGE) --lib --release
.PHONY: build\:release\:lib

build\:release\:cli: # Build only -cli package with release mode
	cargo build --package $(PACKAGE)-cli --bins --release
.PHONY: build\:release\:cli

build\:release\:web: # Build only -web package with release mode
	cargo build --package $(PACKAGE)-web --bins --release
.PHONY: build\:release\:web

build\:debug: # Build all packages with debug mode [synonym: build]
	cargo build --workspace
.PHONY: build\:debug

build\:release: # Build all packages with release mode
	cargo build --workspace --release
.PHONY: build\:release

build: build\:debug
.PHONY: build

# util
watch\:lib: # Monitor build process for the lib package (require cargo-watch)
	@cargo watch --exec 'build --package $(PACKAGE) --lib' --delay 0.3
.PHONY: watch\:lib

watch\:cli: # Monitor build process for -cli package (require cargo-watch)
	@cargo watch --exec 'build --package $(PACKAGE)-cli --bins' --delay 0.3
.PHONY: watch\:cli

watch\:web: # Monitor build process for -web package (require cargo-watch)
	@cargo watch --exec 'build --package $(PACKAGE)-web --bins' --delay 0.3
.PHONY: watch\:web

clean: # Remove cache and built artifacts
	@cargo clean
.PHONY: clean

package\:%: # Create a package
	@cargo package --manifest-path src/$(subst package:,,$@)/Cargo.toml
.PHONY: package

help: # Display this message
	@set -uo pipefail; \
	grep --extended-regexp '^[0-9a-z\:\\\%]+: ' \
		$(firstword $(MAKEFILE_LIST)) | \
		grep --extended-regexp ' # ' | \
		sed --expression='s/\([a-z0-9\-\:\ ]*\): \([a-z0-9\-\:\ ]*\) #/\1: #/g' | \
		tr --delete \\\\ | \
		awk 'BEGIN {FS = ": # "}; \
			{printf "\033[38;05;222m%-18s\033[0m %s\n", $$1, $$2}' | \
		sort
.PHONY: help

.DEFAULT_GOAL = build:release
default: build\:release
