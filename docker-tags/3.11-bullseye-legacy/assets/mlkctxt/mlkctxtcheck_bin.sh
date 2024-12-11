#!/bin/bash

# Checks the current context
# Returns:
#   - 0 if set context match argument (including NOTNULL)
#   - 1 if argument do not match set context
#   - 2 if no argument was provided

if [ -z "$1" ] ; then

  exit 2;

else

  # Check for not null condition and null context
  if [ "${1}" = "NOTNULL" ] ; then

    if [ "$(mlkctxt)" = "" ] ; then exit 1 ; fi

  else

    if [ ! "$(mlkctxt)" = "$1" ] ; then exit 1 ; fi

  fi

fi

exit 0
