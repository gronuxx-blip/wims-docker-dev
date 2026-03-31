FROM debian:12
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y --no-install-recommends install \
    subversion apache2 make g++ \
    gnuplot pari-gp flex bison perl \
    imagemagick libgd-dev libfl-dev \
    wget curl maxima maxima-share gap \
    octave graphviz povray yacas \
    locales locales-all patch bc

RUN adduser --disabled-password --gecos '' wims
USER wims
WORKDIR /home/wims

RUN svn checkout \
    https://subversion.renater.fr/anonscm/svn/wimsdev/trunk \
    wims

RUN cd wims && yes "" | ./compile --mathjax --jmol --modules --geogebra

USER root
RUN a2enmod cgid && a2enmod remoteip

EXPOSE 80
```
Clique **"Commit new file"**.

---

### Fichier 2 — tape ce nom exactement :
```
.github/workflows/build.yml
