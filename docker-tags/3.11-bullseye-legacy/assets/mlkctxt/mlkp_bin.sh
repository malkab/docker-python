#!/bin/bash

# returns the ENVVAR name from a JSON path like a.b.c

A="${1//./_}"
A=MLKC_${A^^}
echo "${!A}"
