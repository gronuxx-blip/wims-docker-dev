#!/bin/bash
# ============================================
# 1. Création des dossiers nécessaires
# ============================================
mkdir -p /home/wims/wims/tmp/log
mkdir -p /home/wims/wims/tmp/sessions
mkdir -p /home/wims/public_html
chown -R wims:wims /home/wims/wims/tmp
chown -R wims:wims /home/wims/wims/log
chown -R wims:wims /home/wims/public_html
# Permissions pour qu'Apache puisse accéder aux dossiers
chmod o+x /home/wims
chmod o+x /home/wims/wims
chmod o+x /home/wims/wims/tmp
chmod o+x /home/wims/wims/tmp/log
chmod 777 /home/wims/wims/tmp/sessions
chmod o+w /home/wims/wims/log
# ============================================
# 2. Configuration de WIMS
# ============================================
config_file=/home/wims/wims/log/wims.conf
if [ ! -f "$config_file" ]; then
    echo "threshold1=$(($(grep -c processor /proc/cpuinfo) * 150))" > "$config_file"
    echo "threshold2=$(($(grep -c processor /proc/cpuinfo) * 300))" >> "$config_file"
    echo "manager_site=127.0.0.1" >> "$config_file"
    chown wims:wims "$config_file"
    chmod go-rwx "$config_file"
fi
# ============================================
# 3. Configuration des logiciels tiers
# ============================================
echo "pkg load statistics" >> /etc/octaverc
echo "read+write* = /home/wims/wims/tmp/sessions" >> /etc/povray/3.7/povray.conf
echo 'SetUserPreference( "UseColorPrompt", false );' > /usr/lib/gap/gap.ini
# ============================================
# 4. Configuration des droits et Apache
# ============================================
cd /home/wims/wims
./bin/setwrapexec
./bin/setwimsd
./bin/apache-config
a2enmod cgi
# ============================================
# 5. Lancement des démons WIMS
# ============================================
su -s /bin/bash wims -c "cd /home/wims/wims/public_html && ../src/Wimslogd/wimslogd" &
sleep 2
PID=$(pgrep wimslogd)
echo $PID > /home/wims/wims/tmp/log/wimslogd.pid
chown wims:wims /home/wims/wims/tmp/log/wimslogd.pid
sleep 1
su -s /bin/bash wims -c "cd /home/wims/wims && ./bin/wimsd" &
sleep 2
# ============================================
# 6. Lancement d'Apache au premier plan
# ============================================
exec apachectl -D FOREGROUND
