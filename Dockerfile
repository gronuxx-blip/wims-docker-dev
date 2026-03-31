FROM debian:12
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y --no-install-recommends install \
    apache2 \
    make \
    g++ \
    gnuplot \
    pari-gp \
    flex \
    bison \
    perl \
    imagemagick \
    libgd-dev \
    libfl-dev \
    wget \
    curl \
    maxima \
    maxima-share \
    gap \
    octave \
    octave-statistics \
    graphviz \
    ldap-utils \
    scilab-cli \
    libwebservice-validator-html-w3c-perl \
    qrencode \
    fortune \
    zip \
    unzip \
    openbabel \
    povray \
    yacas \
    locales \
    locales-all \
    patch \
    bc \
    libgmp-dev

RUN adduser --disabled-password --gecos '' wims
USER wims
WORKDIR /home/wims

# Les sources sont dans le dossier wims/
COPY --chown=wims:wims wims/ /home/wims/wims/

RUN chmod +x /home/wims/wims/compile && \
    cd /home/wims/wims && yes "" | ./compile --mathjax --jmol --modules --geogebra

USER root
RUN a2enmod cgid && a2enmod remoteip

EXPOSE 80
