#!/bin/bash

# -----------------
#
# An utility to set env vars contexts.
#
# -----------------

# VERSION
MLKCTXT_VERSION=0.0.2

# Version function
function version() {

  echo $MLKCTXT_VERSION

}

# Help function
function help() {
cat <<EOF

Version ${MLKCTXT_VERSION}

ENVVARS contexts environments.

To initialise an mlkctxt set up in the current folder:

  mlkctxt init

To set an environment:

  . mlkctxt [context name]

Inside context definitions, variables in the context can be referenced
with \$[path.to.var]\$. Variables in system context can be referenced by
\$[SYSTEM.path.to.var]\$.

If successfull, the set context will be stored at ENVVAR MLKCTXT_SET.

ENVVARS at ~/.mlkctxt/system.yaml are also processed and added to the
environment.

The context name NOTNULL is internally reserved and is used to test with the -c
option that a context (any context) has been set.

Calling the script without parameters returns the currently set environment or
empty if no context is set.

To create template files, sufix them with .mlkctxt_template and use
replacement string [{PATH TO VAR}], like for example [{a.b.c}]. mlkctxt
will create parsed versions of them that are added to the .gitignore file.

System-wide ENVVARS are stored at:

  ~/.mlkctxt/system.yaml

Use the mlkp command to access the ENVVARS by path:

  A=\$(mlkp git.backup)

Other options:

Usage:
  -l          returns available contexts
  -m PREFIX   list ENVVARS starting with PREFIX
  -n          list ENVVARS with the default prefix MLKC_
  -p          returns the folder where contexts are defined for the current
              folder
  -v          version
  -h          this help

EOF
}

# Init a mlkctxt
function init() {

  # Create context folder
  if [ ! -d mlkctxt ] ; then

    mkdir -p mlkctxt/contexts

    # Add .gitignore
    echo contexts/* > mlkctxt/.gitignore

    cat > mlkctxt/mlkctxt.yaml <<'endmsg'
# Variable paths are converted into case-insensitive envvars, so don't rely on
# case to differentiate variables or paths. Do not end variable paths with the
# reserved words "default" or "NOTNULL".

# WARNING! Don't use "-" in variable paths.

# Use $[SYSTEM.a.b]$ to reference a path in the system context. Use $[a.b.c]$
# to reference local variables.
# Use ${command}$ to launch shell commands, like for example ${date}$. However,
# this process executes in a blank environment.
# References to another variable paths and commands can be safely mixed in a
# variable.

# Reference variables in .mlkctxt_template files with [{a.b.c}].

# Refer to ENVVARS in scripts using paths without context with the mlkp command,
# like in:
#   mlkp a.b.c
#   mlkp SYSTEM.a.b.c

# The list of available context. The "system", "SYSTEM", "default", and
# "NOTNULL" context names are reserved and can't be used. This section is
# optional if there are no other contexts aside the default one. There is no
# need to specify the default context anyway.
contexts:
  - context_a
  - context_b
  - context_c

# SSH connection
ssh:
  # This is a default value to be used in all contexts
  host: "the_default_host"
  # The "port" value depends on the context
  port:
    default: the_default_port
    context_a: context_a_port
    context_b: context_b_port
    context_c: context_c_port
  # This is a compound variable joining a system config variable and a local one
  # use $[SYSTEM.a.b]$ to reference a system context variable
  aCompoundVar: $[dev_db.user]$

number: 466
string: A string with spaces

# Development DB
dev_db:
  host: the_default_host
  port: $[dev_db.host]$_whatever
  # This, however, will use the default value for "default", "context_a", and
  # "context_b", but change for "context_c"
  user:
    default: the_default_user
    context_c: $[ssh.port]$_context_c
endmsg

    # Check if there is no system config file, create it
    if [ ! -d ~/.mlkctxt ] ; then

      mkdir -p ~/.mlkctxt/contexts

      cat > ~/.mlkctxt/system.yaml <<'endmsg'
# Variable paths are converted into case-insensitive envvars, so don't rely on
# case to differentiate variables or paths. Do not end variable paths with the
# reserved words "default" or "NOTNULL".

# Use $[a.b.c]$ to refer to other variables in this file.

# Use ${command}$ to launch shell commands, like for example ${date}$. However,
# this process executes in a blank environment.
# References to another variable paths and commands can be safely mixed in a
# variable.

# WARNING! Don't use "-" in variable paths.

# Refer to ENVVARS in scripts using paths without context with the mlkp command,
# like in:
#   mlkp a.b.c
#   mlkp SYSTEM.a.b.c

number: 466
string: A string with spaces

# SSH connection
ssh:
  # This is a default value to be used in all contexts
  host: the_system_host
  # The "port" value depends on the context
  port: the_system_port
  # This is a compound variable
  aCompoundVar: $[dev_db.user]$

# Development DB
dev_db:
  host: the_system_db_host
  port: $[dev_db.host]$_system_whatever
  # This, however, will use the default value for "default" and
  # "kepler_localhost" but change for "kepler_remote"
  user: $[ssh.port]$_the_system_db_user
endmsg

    fi

    __mlkctxt ~/.mlkctxt $(pwd)/mlkctxt

    echo mlkctxt initialized

  else

    echo mlkctxt already initialized in current folder

  fi

}

# Function for processing templates
function processTemplates(){

  cd ..

  touch .gitignore

  # An array to store path substitutions in templates
  PATHS=()

  # Get all paths within ${]] for all templates
  for T in $(find . -type f -iname '*.mlkctxt_template' 2>/dev/null | sort) ; do

    PATHS+=($(grep -Po '\[{.*?}\]' $T | sed s/\\[\{//g | sed s/\}\\]//g))

  done

  # The string to include at the end of the .gitignore
  FOR_GITIGNORE="# Added by mlkctxt - v${MLKCTXT_VERSION}\n# -------------------"

  # Depends on found paths, for processing templates with no substitutions
  if [ "${#PATHS[@]}" -gt 0 ]; then

    # For storing the substitutions to perform on the templates
    SUBSTITUTIONS=""

    # Create substitutions based on found paths
    for S in "${PATHS[@]}" ; do

      SUBSTITUTIONS="${SUBSTITUTIONS}-e 's|\[{${S}}\]|$(mlkp $S)|' "

    done

    # Run SED substitutions on all template files in the folder tree Creates a new
    # file without the template suffix and updates the string to be added at the
    # end of the .gitignore. Redirecting error for bad permissions to /dev/null.
    for T in $(find . -type f -iname '*.mlkctxt_template' 2>/dev/null | sort) ; do

      echo Processing template $T...

      NEW_FILE_NAME="${T%.*}"

      eval "sed ${SUBSTITUTIONS} ${T} > ${NEW_FILE_NAME}"

      FOR_GITIGNORE="${FOR_GITIGNORE}\n${NEW_FILE_NAME#*/}"

    done

  else

    # Process with no substitutions
    for T in $(find . -type f -iname '*.mlkctxt_template' 2>/dev/null | sort) ; do

      echo Processing template $T...

      NEW_FILE_NAME="${T%.*}"

      # Just copy the file to the new name without sed anything
      cp ${T} ${NEW_FILE_NAME}

      FOR_GITIGNORE="${FOR_GITIGNORE}\n${NEW_FILE_NAME#*/}"

    done

  fi

  echo Updating .gitignore...

  # Deletes all lines at .gitignore from the # Added by tmuxenv.sh
  # line to the end
  sed -n '/# Added by mlkctxt/q;p' .gitignore > .gitignore-new

  # Process the new .gitignore
  rm .gitignore

  mv .gitignore-new .gitignore

  printf "${FOR_GITIGNORE}" >> .gitignore

  echo Done

  return 0

}

function listVars() {
# List set of MLKC_ set variables or any other prefixed env var

  env | grep $ENVVARPREFIX | sort

}

# Return the mlkctxt folder setting contexts for the current folder
function contextFolder() {

  cdToContexts

  echo $(pwd)

  return

}

# cd to the mlkctxt folder, remembering the current folder
function cdToContexts() {

  CONTEXTPATH=

  CURRENTPATH=$(pwd)

  while [[ "$CURRENTPATH" != "" && ! -e "$CURRENTPATH/mlkctxt" ]]; do
    CURRENTPATH=${CURRENTPATH%/*}
  done

  if [ -z "$CURRENTPATH" ] ; then

    echo "No contexts definition available, create one with mlkctxt init"

  else

    CONTEXTPATH=$CURRENTPATH/mlkctxt

    cd $CONTEXTPATH

  fi

  return

}

# Read available contexts from mlkctxt.yaml
function getAvailableContexts() {

  cdToContexts

  AVAILABLECONTEXTS=

  # Check mlkctxt folder found
  if [ ! -z "$CONTEXTPATH" ] ; then

    CONTEXTS=($(cat $(pwd)/mlkctxt.yaml | shyaml get-values contexts 2>/dev/null))

    AVAILABLECONTEXTS=("${CONTEXTS[@]}" "default")

  fi

  return

}

# Prints available contexts
function echoAvailableContexts() {

  getAvailableContexts

  echo Available contexts in $CONTEXTPATH:

  for C in "${AVAILABLECONTEXTS[@]}" ; do
    echo $C
  done

  return

}

# Process function
function process() {

  # Load app-wide settings
  if [ -f ~/.mlkctxt/contexts/system ] ; then

    source ~/.mlkctxt/contexts/system

  fi

  # Load selected context
  if [ -f "contexts/${MLKCTXT}" ] ; then

    source ./contexts/$MLKCTXT

  fi

  echo Context $MLKCTXT set

  export MLKCTXT_SET=$MLKCTXT

}

# ----------------
#
# Main
#
# ----------------

# Store current path
CURRENT_PATH=$(pwd)

# Arguments
while getopts "hlnm:vcp" opt
do
	case "$opt" in
    l)  echoAvailableContexts
        exit 0
        ;;
    p)  contextFolder
        exit 0
        ;;
    m)  ENVVARPREFIX=$OPTARG
        listVars
        exit 0
        ;;
    n)  ENVVARPREFIX=MLKC_
        listVars
        exit 0
        ;;
    h)  help
        exit 0
        ;;
    v)  version
        exit 0
        ;;
    \?) help
        exit 0
        ;;
	esac
done

# Check if command is init
if [ "${1}" == "init" ] ; then

  init

# Activate a context
elif [ ! -z $1 ] ; then

  MLKCTXT=$1

  getAvailableContexts

  if [ ! -z "$AVAILABLECONTEXTS" ] ; then

    # Delete existing contexts
    mkdir -p $(pwd)/contexts
    mkdir -p ~/.mlkctxt/contexts
    rm -Rf contexts/*
    rm -Rf ~/.mlkctxt/contexts/*

    __mlkctxt ~/.mlkctxt $(pwd)

    # Check if the context is available
    if [[ ! " ${AVAILABLECONTEXTS[*]} " =~ " ${MLKCTXT} " ]] ; then

      export MLKCTXT_SET=

      echo Context $MLKCTXT not defined at $(pwd)

      echoAvailableContexts

      echo

    else

      process

      processTemplates

    fi

  fi

# Check if no argument, return selected context
else

  if [ -z $MLKCTXT_SET ] ; then

    echo

  else

    echo $MLKCTXT_SET

  fi

fi

# Restore
cd $CURRENT_PATH
