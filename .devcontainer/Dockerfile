FROM mcr.microsoft.com/vscode/devcontainers/python:0-3.9

RUN apt-get update && \
        apt-get install -y python3-venv moreutils && \
        rm -rf /var/lib/apt/lists/*

USER vscode

# Based on a Gist by @jthorniley: https://gist.github.com/jthorniley/fba81c62a9d45c723777c7205ff96481
RUN curl -sSL https://install.python-poetry.org | python3 -
