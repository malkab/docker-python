#!/bin/bash

# --------------------
#
# Builds the image.
#
# --------------------
docker build --force-rm -t malkab/python:3.11-bullseye .
