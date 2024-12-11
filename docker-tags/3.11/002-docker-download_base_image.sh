#!/bin/bash

# Downloads the base image (just in case it dissapears from the Docker Hub)

docker image pull mcr.microsoft.com/devcontainers/python:3.11-bookworm

docker save -o base_image mcr.microsoft.com/devcontainers/python:3.11-bookworm

tar -jcvf mcr_microsoft_com_devcontainers_python_3.11-bookworm.tar.bz2 base_image

rm base_image