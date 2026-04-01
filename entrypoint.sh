#!/bin/bash

# ============================================
# 1. Création des dossiers nécessaires
# ============================================
mkdir -p /home/wims/tmp/log
mkdir -p /home/wims/tmp/sessions
mkdir -p /home/wims/public_html

chown -R wims:wims /home/wims/tmp
chown -R wims:wims /home/wims/public_html
chown -R wims:wims /home/wims/log

# Permissions pour qu'Apache puisse accéder aux dossiers
chmod o+x /home/wims
chmod o+x /home/wims/wims

# ============================================
# 2. Copier wims.cgi au bon endroit
# ============================================
# A veérifier cp /home/wims/wims/public_html/wims /home/wims/public_html/wims.cgi
chown wims:wims /home/wims/public_html/wims.cgi
chmod +x /home/wims/public_html/wims.cgi

# ============================================
# 3. Configuration de WIMS
# ============================================
config_file=/home/wims/log/wims.conf
if [ ! -f "$config_file" ]; then
    echo "threshold1=$(($(grep -c processor /proc/cpuinfo) * 150))" > "$config_file"
    echo "threshold2=$(($(grep -c processor /proc/cpuinfo) * 300))" >> "$config_file"
    chown wims:wims "$config_file"
    chmod go-rwx "$config_file"
    if [ -n "$MANAGER_SITE" ]; then
        if [ "$MANAGER_SITE" = "auto" ]; then
            echo "manager_site=$(route -n | grep "UG" | awk '{print $2}')" >> "$config_file"
        else
            echo "manager_site=$MANAGER_SITE" >> "$config_file"
        fi
    fi
fi

# ============================================
# 4. Configuration des logiciels tiers
# ============================================
# Octave
echo "pkg load statistics" >> /etc/octaverc

# Povray
echo "read+write* = /home/wims/tmp/sessions" >> /etc/povray/3.7/povray.conf

# GAP
echo 'SetUserPreference( "UseColorPrompt", false );' > /usr/lib/gap/gap.ini

# ============================================
# 5. Configuration des droits et Apache
# ============================================
cd /home/wims/wims
./bin/setwrapexec
./bin/setwimsd
./bin/apache-config
# A vérifier ln -sf /etc/apache2/conf-available/wims.conf /etc/apache2/conf-enabled/wims.conf 2>/dev/null || true
a2enmod cgi

# ============================================
# 6. Lancement de wimsd
# ============================================
cd /home/wims
su - wims -c "cd /home/wims && ./wims/bin/wimsd &"
sleep 2

# ============================================
# 7. Lancement d'Apache au premier plan
# ============================================
exec apachectl -D FOREGROUND
