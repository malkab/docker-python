#!/bin/bash

# Locale
export LOCALE=es_ES.UTF-8

# Set up
ln -fs /usr/share/zoneinfo/Europe/Madrid /etc/localtime

export DEBIAN_FRONTEND=noninteractive

apt-get update

echo
echo ---------------------------
echo Locales
echo ---------------------------
echo

apt-get install -y debconf-utils

apt-get install -y \
  libreadline8 \
  locales \
  tzdata

dpkg-reconfigure --frontend noninteractive tzdata

# Locales
sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sed -i -e 's/# es_ES.UTF-8 UTF-8/es_ES.UTF-8 UTF-8/' /etc/locale.gen
sed -i -e 's/# en_US.ISO-8859-15 ISO-8859-15/en_US.ISO-8859-15 ISO-8859-15/' /etc/locale.gen
sed -i -e 's/# en_GB ISO-8859-1/en_GB ISO-8859-1/' /etc/locale.gen
sed -i -e 's/# en_GB.ISO-8859-15 ISO-8859-15/en_GB.ISO-8859-15 ISO-8859-15/' /etc/locale.gen
sed -i -e 's/# en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen
sed -i -e 's/# es_ES ISO-8859-1/es_ES ISO-8859-1/' /etc/locale.gen
sed -i -e 's/# es_ES.UTF-8 UTF-8/es_ES.UTF-8 UTF-8/' /etc/locale.gen
sed -i -e 's/# es_ES@euro ISO-8859-15/es_ES@euro ISO-8859-15/' /etc/locale.gen
sed -i -e 's/# de_DE ISO-8859-1/de_DE ISO-8859-1/' /etc/locale.gen
sed -i -e 's/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen
sed -i -e 's/# de_DE@euro ISO-8859-15/de_DE@euro ISO-8859-15/' /etc/locale.gen
sed -i -e 's/# fr_FR ISO-8859-1/fr_FR ISO-8859-1/' /etc/locale.gen
sed -i -e 's/# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen
sed -i -e 's/# fr_FR@euro ISO-8859-15/fr_FR@euro ISO-8859-15/' /etc/locale.gen
sed -i -e 's/# it_IT ISO-8859-1/it_IT ISO-8859-1/' /etc/locale.gen
sed -i -e 's/# it_IT.UTF-8 UTF-8/it_IT.UTF-8 UTF-8/' /etc/locale.gen
sed -i -e 's/# it_IT@euro ISO-8859-15/it_IT@euro ISO-8859-15/' /etc/locale.gen

echo
echo ---------------------------
echo apt-get install
echo ---------------------------
echo

apt-get install -y -f \
  apt-utils \
  cmake \
  curl \
  git \
  gdb \
  inotify-tools \
  less \
  mlocate \
  p7zip-full \
  sudo \
  vim \
  x11-apps

apt-get -y upgrade

apt-get clean autoclean

apt-get autoremove --yes

ldconfig

echo
echo ---------------------------
echo pip install
echo ---------------------------
echo
pip install --upgrade pip

pip install \
  ipython \
  pyinstaller \
  pytest \
  pytest-watch \
  build \
  readline

echo
echo ---------------------------
echo pipx install
echo ---------------------------
echo
python3 -m pip install pipx
python3 -m pipx ensurepath

# Clean up
rm -rf /var/lib/apt/lists/*

locale-gen

update-locale LANG=$LOCALE

ldconfig

# Some ln -s
ln -s /usr/bin/ipython3 /usr/bin/ipython

echo
echo ---------------------------
echo Install mlkctxt
echo ---------------------------
echo
cd /mlkctxt
./install.sh

echo
echo ---------------------------
echo Install Node.js
echo ---------------------------
echo
cd /node
cp -R * /usr/local/

# Clean up
rm -Rf /node
rm -Rf /mlkctxt

echo
echo ---------------------------
echo Create users
echo ---------------------------
echo

# Linux
groupadd -g 1000 user1000
useradd -u 1000 -m -d '/home/user1000' -g user1000 user1000
chown -R 1000:1000 /home/user1000
usermod -a -G sudo user1000

groupadd -g 1001 user1001
useradd -u 1001 -m -d '/home/user1001' -g user1001 user1001
chown -R 1001:1001 /home/user1001
usermod -a -G sudo user1001

groupadd -g 1002 user1002
useradd -u 1002 -m -d '/home/user1002' -g user1002 user1002
chown -R 1002:1002 /home/user1002
usermod -a -G sudo user1002

groupadd -g 1003 user1003
useradd -u 1003 -m -d '/home/user1003' -g user1003 user1003
chown -R 1003:1003 /home/user1003
usermod -a -G sudo user1003

groupadd -g 1004 user1004
useradd -u 1004 -m -d '/home/user1004' -g user1004 user1004
chown -R 1004:1004 /home/user1004
usermod -a -G sudo user1004

# Mac
useradd -u 500 -m -d '/home/user500' -g 20 user500
chown -R 500:20 /home/user500
usermod -a -G sudo user500

useradd -u 501 -m -d '/home/user501' -g 20 user501
chown -R 501:20 /home/user501
usermod -a -G sudo user501

useradd -u 502 -m -d '/home/user502' -g 20 user502
chown -R 502:20 /home/user502
usermod -a -G sudo user502

useradd -u 503 -m -d '/home/user503' -g 20 user503
chown -R 503:20 /home/user503
usermod -a -G sudo user503

useradd -u 504 -m -d '/home/user504' -g 20 user504
chown -R 504:20 /home/user504
usermod -a -G sudo user504

# Replace sudoers
rm /etc/sudoers
mv /sudoers /etc/sudoers
chmod 0440 /etc/sudoers
