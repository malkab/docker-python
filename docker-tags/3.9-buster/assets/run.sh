#!/bin/bash

# Process group and user
if [ "$PYTHONGROUPID" -ne "0" ]; then

  groupadd -g $PYTHONGROUPID python

fi

if [ "$PYTHONUSERID" -ne "0" ]; then

  useradd -u $PYTHONUSERID -m -d '/home/python' -g python python
  chown -R $PYTHONUSERID:$PYTHONGROUPID /home/python

fi

# Run the final command
if [ "$PYTHONGROUPID" -eq "0" ]; then

  if [ "$PYTHONUSERID" -eq "0" ]; then

    if [ ! -z "${COMMAND}" ] ; then

      exec gosu root /bin/bash -c "${COMMAND}"

    else

      exec gosu root /bin/bash

    fi

  fi

fi

if [ "$PYTHONGROUPID" -ne "0" ]; then

  if [ "$PYTHONUSERID" -ne "0" ]; then

    if [ ! -z "${COMMAND}" ] ; then

      exec gosu python /bin/bash -c "${COMMAND}"

    else

      exec gosu python /bin/bash

    fi

  fi

fi
