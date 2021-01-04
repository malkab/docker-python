FROM python:3.9-buster

LABEL author="Juan Pedro Perez"
LABEL email="jp.perez.alcantara@gmail.com"

WORKDIR /

ADD assets/keyboard_selections.conf /
ADD assets/dot.bashrc /root/.bashrc
ADD assets/dot.vimrc /root/.vimrc
ADD assets/config.sh /

RUN chmod 755 /config.sh
RUN /config.sh

RUN rm /config.sh

ENTRYPOINT [ "/bin/bash" ]
