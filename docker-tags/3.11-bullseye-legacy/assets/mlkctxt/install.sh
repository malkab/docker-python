#!/bin/bash

# Install dependencies for the mlkctxt script
sudo pip3 install shyaml

# Install
sudo rm -f /usr/local/bin/__mlkctxt
sudo rm -f /usr/local/bin/mlkctxt
sudo rm -f /usr/local/bin/mlkp
sudo rm -f /usr/local/bin/mlkctxtcheck

sudo cp ./mlkctxt /usr/local/bin/__mlkctxt
sudo cp ./mlkctxt_bin.sh /usr/local/bin/mlkctxt
sudo cp ./mlkp_bin.sh /usr/local/bin/mlkp
sudo cp ./mlkctxtcheck_bin.sh /usr/local/bin/mlkctxtcheck

sudo chmod 755 /usr/local/bin/__mlkctxt
sudo chmod 755 /usr/local/bin/mlkctxt
sudo chmod 755 /usr/local/bin/mlkp
sudo chmod 755 /usr/local/bin/mlkctxtcheck
