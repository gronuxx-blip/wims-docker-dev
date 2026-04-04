FROM debian:12
ARG DEBIAN_FRONTEND=noninteractive

# ============================================
# 1. Installation des paquets
# ============================================
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
    libgmp-dev \
    python3 \
    texlive-base \
    units-filter \
    liburi-perl \
    python3-bs4 \
    python3-jinja2 \
    python3-cssmin \
    python3-lxml \
    # Nécessaire pour apache-config
    lsb-release \
    net-tools

# ============================================
# 2. Compilation de WIMS
# ============================================
RUN adduser --disabled-password --gecos '' wims
USER wims
WORKDIR /home/wims

COPY --chown=wims:wims wims/ /home/wims/wims/

RUN chmod +x /home/wims/wims/compile && \
    cd /home/wims/wims && yes "" | ./compile --mathjax --jmol --modules --geogebra

# ============================================
# 3. Configuration au build (comme Gianluca)
# ============================================
USER root
RUN a2enmod cgid && \
    a2enmod remoteip && \
    # GAP symlink
    ln -s gap /usr/bin/gap.sh && \
    # Octave
    echo "pkg load statistics" >> /etc/octaverc && \
    # Povray
    echo "read+write* = /home/wims/wims/tmp/sessions" >> /etc/povray/3.7/povray.conf && \
    # Configuration WIMS
    cd /home/wims/wims && \
    ./bin/setwrapexec && \
    ./bin/setwimsd && \
    ./bin/apache-config

# ============================================
# 4. Entrypoint
# ============================================
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 80
