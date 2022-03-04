#!/usr/bin/env bash

./scripts/regenerate_sources.py < sources.json | sponge sources.json
