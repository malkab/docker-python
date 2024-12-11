#!/bin/bash

. ./env

# --------------------
#
# Push the image to GitHub, private.
#
# --------------------
echo $(mlkp SYSTEM.github_docker_registry_token) | docker login ghcr.io -u malkab --password-stdin

docker push ghcr.io/malkab/python:3.11-vscode_devcontainer