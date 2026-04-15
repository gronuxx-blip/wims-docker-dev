FROM debian:12
ARG DEBIAN_FRONTEND=noninteractive

# ============================================
# 1. Installation des paquets
# ============================================
RUN apt-get update && apt-get -y --no-install-recommends install \
    apache2 \
    make \
    g++ \
    texlive-base \
    texlive-latex-base \
    gnuplot \
    pari-gp \
    flex \
    bison \
    perl \
    liburi-perl \
    imagemagick \
    libgd-dev \
    libfl-dev \
    wget \
    curl \
    yacas \
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
    chemeq \
    libgmp-dev \
    python3 \
    units-filter \
    macaulay2 \
    python3-bs4 \
    python3-jinja2 \
    python3-cssmin \
    python3-lxml \
    lsb-release \
    net-tools \
    locales locales-all

# ============================================
# 2. Copie des sources
# ============================================
RUN adduser --disabled-password --gecos '' wims
USER wims
WORKDIR /home/wims

COPY --chown=wims:wims wims/ /home/wims/

# ============================================
# 3. Première compilation avec téléchargements
# (MathJax, JMol, GeoGebra, modules)
# → mis en cache par Docker après le premier build
# ============================================
RUN chmod +x /home/wims/wims/compile && \
    cd /home/wims/wims && \
    yes "" | ./compile --mathjax --jmol --modules --geogebra

# ============================================
# 4. Deuxième compilation sans téléchargements
# → recompile uniquement le code C si les sources changent
# ============================================
RUN cd /home/wims/wims && \
    yes "" | ./compile

# ============================================
# 5. Configuration au build
# ============================================
USER root
RUN a2enmod cgid && \
    a2enmod remoteip && \
    ln -s gap /usr/bin/gap.sh && \
    echo "pkg load statistics" >> /etc/octaverc && \
    echo "read+write* = /home/wims/wims/tmp/sessions" >> /etc/povray/3.7/povray.conf && \
    cd /home/wims/wims && \
    ./bin/setwrapexec && \
    ./bin/setwimsd && \
    ./bin/apache-config

# ============================================
# 6. Entrypoint
# ============================================
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 80
