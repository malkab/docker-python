FROM python:3.9-buster

LABEL author="Juan Pedro Perez"
LABEL email="jp.perez.alcantara@gmail.com"

WORKDIR /

# Default users
ENV PYTHONGROUPID 0
ENV PYTHONUSERID 0

ADD assets/keyboard_selections.conf /
ADD assets/dot.bashrc /root/.bashrc
ADD assets/dot.vimrc /root/.vimrc
ADD assets/dot.bashrc /etc/skel/.bashrc
ADD assets/dot.vimrc /etc/skel/.vimrc
ADD assets/gosu /usr/bin
ADD assets/run.sh /usr/bin
ADD assets/config.sh /

RUN chmod 755 -R /usr/bin/ ; chmod 755 /config.sh ; /config.sh ; rm /config.sh

ENTRYPOINT [ "/usr/bin/run.sh" ]
