#!/bin/bash

# This script generates a requirements.txt for Heroku to use.

pip install poetry
poetry export -o requirements.txt
