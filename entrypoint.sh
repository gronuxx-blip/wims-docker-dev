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
mkdir -p /home/wims/log/classes
chown wims:wims /home/wims/log/classes
chmod 775 /home/wims/log/classes
# Permissions pour qu'Apache puisse accéder aux dossiers
chmod o+x /home/wims
chmod o+x /home/wims/tmp
chmod o+x /home/wims/tmp/log
chmod 777 /home/wims/tmp/log
chmod 777 /home/wims/sessions
chmod 777 /home/wims/tmp
chmod o+w /home/wims/log
#Pour activer le mode dev
chown wims:wims /home/wims/public_html/modules/devel
chmod 775 /home/wims/public_html/modules/devel
# Copie des scripts d'indexation (toujours à jour)
cp -f /opt/wims-scripts/.build-index /home/wims/log/classes/.build-index
cp -f /opt/wims-scripts/.build-teacher /home/wims/log/classes/.build-teacher
chmod +x /home/wims/log/classes/.build-*
chown wims:wims /home/wims/log/classes/.build-*
mkdir -p /home/wims/log/forums
cp -f /opt/wims-scripts/.build-index-forums /home/wims/log/forums/.build-index
chmod +x /home/wims/log/forums/.build-index
chown wims:wims /home/wims/log/forums/.build-index
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
fi
# Permissions toujours appliquées
chown wims:wims "$config_file"
chmod 600 "$config_file"

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
sed -i 's/export APACHE_RUN_USER=www-data/export APACHE_RUN_USER=wims/' /etc/apache2/envvars
sed -i 's/export APACHE_RUN_GROUP=www-data/export APACHE_RUN_GROUP=wims/' /etc/apache2/envvars
# ============================================
# 5. Lancement des démons WIMS
# ============================================
su -s /bin/bash wims -c "cd /home/wims/public_html && ../src/Wimslogd/wimslogd" &
sleep 2
PID=$(pgrep wimslogd)
echo $PID > /home/wims/tmp/log/wimslogd.pid
chmod o+w /home/wims/tmp/log/.wimslogd
sleep 1
su -s /bin/bash wims -c "cd /home/wims && ./bin/wimsd" &
sleep 2
# ============================================
# 6. Lancement d'Apache au premier plan
# ============================================
# Apache doit tourner en wims
exec apachectl -D FOREGROUND
