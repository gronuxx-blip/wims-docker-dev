#!/bin/bash
set -e

# Créer les dossiers nécessaires
mkdir -p /home/wims/tmp/log
mkdir -p /home/wims/public_html
chown -R wims:wims /home/wims/tmp
chown -R wims:wims /home/wims/log
chown -R wims:wims /home/wims/public_html

# Configurer les droits sensibles
cd /home/wims/wims
./bin/setwrapexec
./bin/setwimsd

# Configurer Octave
echo "pkg load statistics" >> /etc/octaverc

# Configurer Povray
echo "read+write* = /home/wims/tmp/sessions" >> /etc/povray/3.7/povray.conf

# Configurer GAP
echo 'SetUserPreference( "UseColorPrompt", false );' > /usr/lib/gap/gap.ini

# Configurer Apache
./bin/apache-config
a2enmod cgi

# Lancer wimsd depuis /home/wims
cd /home/wims
su - wims -c "cd /home/wims && ./wims/bin/wimsd &"
sleep 2

# Lancer Apache au premier plan
exec apache2ctl -D FOREGROUND
