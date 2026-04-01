#!/bin/bash
set -e

# Créer les dossiers nécessaires
mkdir -p /home/wims/tmp/log
mkdir -p /home/wims/public_html
chown -R wims:wims /home/wims/tmp
chown -R wims:wims /home/wims/log

# Copier wims.cgi au bon endroit
cp /home/wims/wims/public_html/wims /home/wims/public_html/wims.cgi
chown wims:wims /home/wims/public_html/wims.cgi
chmod +x /home/wims/public_html/wims.cgi

# Configurer Apache
cd /home/wims/wims
./bin/apache-config

# Lancer wimslogd
su - wims -c "/home/wims/wims/src/Wimslogd/wimslogd &"
sleep 1

# Lancer wimsd
su - wims -c "/home/wims/wims/bin/wimsd &"
sleep 1

# Lancer Apache au premier plan
exec apache2ctl -D FOREGROUND
