FROM mcr.microsoft.com/vscode/devcontainers/python:0-3.9

ARG DHALL_VERSION=1.40.2
ARG DHALL_JSON_VERSION=1.7.9
ARG DHALL_LSP_VERSION=1.0.17

RUN apt-get update && \
    apt-get install -y python3-venv && \
    wget -q https://github.com/dhall-lang/dhall-haskell/releases/download/$DHALL_VERSION/dhall-$DHALL_VERSION-x86_64-linux.tar.bz2 \
            https://github.com/dhall-lang/dhall-haskell/releases/download/$DHALL_VERSION/dhall-json-$DHALL_JSON_VERSION-x86_64-linux.tar.bz2 \
            https://github.com/dhall-lang/dhall-haskell/releases/download/$DHALL_VERSION/dhall-lsp-server-$DHALL_LSP_VERSION-x86_64-linux.tar.bz2 && \
    tar xf dhall-$DHALL_VERSION-x86_64-linux.tar.bz2 -C /usr/local && \
    tar xf dhall-json-$DHALL_JSON_VERSION-x86_64-linux.tar.bz2 -C /usr/local && \
    tar xf dhall-lsp-server-$DHALL_LSP_VERSION-x86_64-linux.tar.bz2 -C /usr/local && \
    rm dhall-$DHALL_VERSION-x86_64-linux.tar.bz2 \
       dhall-json-$DHALL_JSON_VERSION-x86_64-linux.tar.bz2 \
       dhall-lsp-server-$DHALL_LSP_VERSION-x86_64-linux.tar.bz2

USER vscode

# Based on a Gist by @jthorniley: https://git.io/JD93B
RUN curl -sSL https://install.python-poetry.org | python3 -
