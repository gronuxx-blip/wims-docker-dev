#!/bin/bash
# ============================================
# 1. Création des dossiers nécessaires
# ============================================
mkdir -p /home/wims/tmp/log
mkdir -p /home/wims/sessions
mkdir -p /home/wims/public_html
chown -R wims:wims /home/wims/tmp
chown -R wims:wims /home/wims/log
chown -R wims:wims /home/wims/public_html
# Permissions pour qu'Apache puisse accéder aux dossiers
chmod o+x /home/wims
chmod o+x /home/wims/tmp
chmod o+x /home/wims/tmp/log
chmod 777 /home/wims/sessions
chmod o+w /home/wims/log
#Pour activer le mode dev
chown wims:wims /home/wims/public_html/modules/devel
chmod 775 /home/wims/public_html/modules/devel
# ============================================
# 2. Configuration de WIMS
# ============================================
config_file=/home/wims/log/wims.conf
if [ ! -f "$config_file" ]; then
    echo "threshold1=$(($(grep -c processor /proc/cpuinfo) * 150))" > "$config_file"
    echo "threshold2=$(($(grep -c processor /proc/cpuinfo) * 300))" >> "$config_file"
    if [ -n "$MANAGER_SITE" ]; then
        echo "manager_site=$MANAGER_SITE" >> "$config_file"
    else
        echo "manager_site=172.17.0.1" >> "$config_file"
    fi
    chown wims:wims "$config_file"
    chmod 600 "$config_file"
fi
# ============================================
# 3. Configuration des logiciels tiers
# ============================================
grep -q "pkg load statistics" /etc/octaverc || echo "pkg load statistics" >> /etc/octaverc
grep -q "wims/sessions" /etc/povray/3.7/povray.conf || echo "read+write* = /home/wims/sessions" >> /etc/povray/3.7/povray.conf
echo 'SetUserPreference( "UseColorPrompt", false );' > /usr/lib/gap/gap.ini
# ============================================
# 4. Configuration des droits et Apache
# ============================================
cd /home/wims
./bin/setwrapexec
./bin/setwimsd
./bin/apache-config
a2enmod cgi
# ============================================
# 5. Lancement des démons WIMS
# ============================================
su -s /bin/bash wims -c "cd /home/wims/public_html && ../src/Wimslogd/wimslogd" &
sleep 2
PID=$(pgrep wimslogd)
echo $PID > /home/wims/tmp/log/wimslogd.pid
chown wims:wims /home/wims/tmp/log/wimslogd.pid
sleep 1
su -s /bin/bash wims -c "cd /home/wims && ./bin/wimsd" &
sleep 2
# ============================================
# 6. Lancement d'Apache au premier plan
# ============================================
exec apachectl -D FOREGROUND
