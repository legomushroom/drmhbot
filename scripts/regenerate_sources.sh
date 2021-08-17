#!/usr/bin/env bash

cat sources.dhall | dhall-to-yaml --generated-comment --output sources.yml
