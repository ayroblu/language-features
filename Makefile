# Example from
# https://tech.davis-hansson.com/p/make/
# Also consider reference at: http://www.gnu.org/software/make/manual/

## Initial setup
SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

ifeq ($(origin .RECIPEPREFIX), undefined)
  $(error This Make does not support .RECIPEPREFIX. Please use GNU Make 4.0 or later)
endif
.RECIPEPREFIX = >

## ------------------------- Main part of the build file
# 1. Build the rust project
# 2. Run the update-markdown func

# Default - top level rule is what gets ran when you run just `make`
build: target/release/language-features run-tsc
.PHONY: build

run: target/release/language-features
> target/release/language-features
.PHONY: run

run-tsc: .build/typescript/.ts-built.sentinel
.PHONY: run-tsc

run-rust: .build/rust/.rust-built.sentinel
.PHONY: run-rust

.build/typescript/.ts-built.sentinel: $(shell rg --files typescript)
> mkdir -p $(@D)
> rsync -a --delete ./typescript ./.build/
> cd ./.build/typescript
> rm -rf ./dist
> yarn
> RESULT=$$(npx tsc 2>&1 || ERROR=true)
> echo '-------'
> echo $$RESULT
> echo '-------'
> cd -
> touch $@

.build/rust/.rust-built.sentinel: build $(shell rg --files rust)
> mkdir -p $(@D)
> LANG=$$(basename "$(@D)")
> rsync -a --delete "./$$LANG" ./.build/
> ./target/release/language-features ./.build/rust/README.md
> cp ./.build/rust/README.md ./rust/README.md
> touch $@

#test: tmp/.tests-passed.sentinel
#.PHONY: test

# Clean up the output directories; since all the sentinel files go under tmp, this will cause everything to get rebuilt
clean:
> rm -rf tmp
> rm -rf target
> rm -rf .build
.PHONY: clean

# Tests - re-ran if any file under src has been changed since tmp/.tests-passed.sentinel was last touched
#tmp/.tests-passed.sentinel: $(shell find src -type f)
#> mkdir -p $(@D)
#> npx gulp test:unit:js
#> touch $@

# Webpack - re-built if the tests have been rebuilt (and so, by proxy, whenever the source files have changed)
#tmp/.packed.sentinel: tmp/.tests-passed.sentinel
#> mkdir -p $(@D)
#> webpack
#> touch $@

target/release/language-features: $(shell find src -type f)
> cargo build --release

# Docker image - re-built if the webpack output has been rebuilt
#out/image-id: tmp/.packed.sentinel
#> mkdir -p $(@D)
#> image_id="example.com/my-app:$$(pwgen -1)"
#> docker build --tag="$${image_id}"
#> echo "$${image_id}" > out/image-id
