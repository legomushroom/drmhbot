FROM mcr.microsoft.com/vscode/devcontainers/python:0-3.9

RUN apt-get update && \
    apt-get install -y python3-venv && \
    wget -q https://github.com/dhall-lang/dhall-haskell/releases/download/1.39.0/dhall-json-1.7.7-x86_64-linux.tar.bz2 https://github.com/dhall-lang/dhall-haskell/releases/download/1.39.0/dhall-lsp-server-1.0.15-x86_64-linux.tar.bz2 && \
    tar xf dhall-json-1.7.7-x86_64-linux.tar.bz2 -C /usr/local && \
    tar xf dhall-lsp-server-1.0.15-x86_64-linux.tar.bz2 -C /usr/local && \
    rm dhall-json-1.7.7-x86_64-linux.tar.bz2 dhall-lsp-server-1.0.15-x86_64-linux.tar.bz2

USER vscode

# Based on a Gist by @jthorniley: https://git.io/JD93B
RUN curl -sSL https://install.python-poetry.org | python3 -
