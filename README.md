# WIMS Docker Dev

Image Docker de WIMS (Web Interactive Multipurpose Server) en version développement, construite automatiquement depuis les sources SVN via GitHub Actions.

## Architecture

```
SVN RENATER (sources dev WIMS)
        ↓
GitHub (wims-docker-dev)
        ↓ GitHub Actions
Docker Hub
        ↓ docker pull
Machine locale / VPS
```

## Démarrage rapide

```bash
docker run -d \
  --restart always \
  --security-opt seccomp:unconfined \
  -p 8080:80 \
  -v <votre-dossier>/wims-data:/home/wims/log \
  -v <votre-dossier>/devel:/home/wims/public_html/modules/devel \
  --name wims \
  <utilisateur>/wims-dev:latest
```

Accès : `http://localhost:8080/wims/`

## Volumes persistants

| Volume | Point de montage | Contenu |
|---|---|---|
| `wims-data` | `/home/wims/log` | Classes, config, données persistantes |
| `devel` | `/home/wims/public_html/modules/devel` | Modules en développement |

## Variables d'environnement

| Variable | Description | Défaut |
|---|---|---|
| `MANAGER_SITE` | IP autorisée pour accéder à l'admin | `172.17.0.1` |
| `WIMS_PASS` | Mot de passe admin permanent | aucun |
| `TZ` | Timezone | UTC |
| `SSMTP_MAILHUB` | Serveur mail relais | aucun |

## Architecture technique

### Utilisateurs

- **Apache** tourne en `wims` (modifié via `envvars`)
- **wimsd** lancé en tant que `wims`
- **wimslogd** lancé en tant que `wims` depuis `/home/wims/public_html`
- **wims.cgi** exécuté en `wims` via Apache

### Structure des dossiers

```
/home/wims/              ← Installation WIMS
├── bin/                 ← Binaires WIMS
├── public_html/         ← Root web (accessible via Apache)
│   └── modules/
│       └── devel/       ← Volume pour modules en dev
├── log/                 ← Volume persistant (classes, config)
│   ├── classes/         ← Classes créées
│   ├── .build-index     ← Script d'indexation
│   └── wims.conf        ← Config WIMS
├── sessions/            ← Sessions utilisateurs
├── tmp/                 ← Fichiers temporaires
└── src/                 ← Sources WIMS

/opt/wims-scripts/       ← Sauvegarde des scripts d'indexation
```

## Points importants

### Sécurité

- `--security-opt seccomp:unconfined` est **obligatoire** pour Maxima (utilise l'appel système `personality`)
- `wims.conf` en `chmod 600` appartenant à `wims` (vérifié par WIMS)

### Scripts d'indexation

Les scripts `.build-index` et `.build-teacher` sont sauvegardés dans `/opt/wims-scripts/` au build Docker et copiés dans le volume à chaque démarrage. Ils permettent à WIMS d'indexer les classes créées.

### Apache en utilisateur `wims`

Apache tourne en `wims` au lieu de `www-data` pour pouvoir lire `wims.conf` (chmod 600). C'est modifié automatiquement dans `/etc/apache2/envvars` par l'`entrypoint.sh`.

## Commandes utiles

```bash
# Voir les logs
docker logs wims

# Entrer dans le conteneur
docker exec -it wims /bin/bash

# Récupérer le mot de passe admin jetable
docker exec -it wims cat /home/wims/tmp/log/.wimspassone

# Reconstruire l'index
docker exec -it wims su -s /bin/bash wims -c "cd /home/wims && yes | ./bin/mkindex"

# Arrêter/démarrer
docker stop wims
docker start wims

# Sauvegarder les données
cp -r <votre-dossier>/wims-data <votre-dossier>/wims-data-backup-$(date +%Y%m%d)
```

## Mettre à jour l'image

```bash
docker pull <utilisateur>/wims-dev:latest
docker stop wims && docker rm wims
# Puis relancer avec docker run ...
```

## Builds GitHub Actions

| Workflow | Usage | Cache |
|---|---|---|
| **Build WIMS Dev** | Build normal avec cache Docker Hub | ✅ Oui |
| **Force Rebuild** | Rebuild complet sans cache | ❌ Non |

Le cache Docker Hub permet des builds rapides (5-10 min) après le premier build complet (~30 min).

## Structure du dépôt

```
wims-docker-dev/
├── Dockerfile          ← Image Docker
├── entrypoint.sh       ← Script de démarrage
├── .github/
│   └── workflows/
│       ├── build.yml         ← Build automatique
│       └── build-force.yml   ← Force rebuild
└── wims/               ← Sources WIMS (depuis SVN)
```

## Synchroniser les sources avec SVN

```bash
cd <votre-dossier-sources>
svn update
git add .
git commit -m "MAJ sources WIMS depuis SVN"
git push origin main
```

GitHub Actions rebuilde automatiquement l'image.

## Problèmes courants

### Le lien "WIMS gestion du site" n'apparaît pas

Vérifiez `manager_site` dans `wims.conf` :
- `172.17.0.1` pour accès local via Docker
- Ajoutez votre IP externe pour accès réseau

### Les classes créées n'apparaissent pas

Le fichier `.index` doit être reconstruit :
```bash
docker exec -it wims /home/wims/log/classes/.build-index
```

### Maxima ne fonctionne pas

Vérifiez que vous avez bien lancé avec `--security-opt seccomp:unconfined`.

## Développement de modules

### Module dans `modules/devel/`

Les modules dans `devel/` sont automatiquement montés en volume. Modifiez directement les fichiers sur votre machine hôte.

### Modifier un module existant (ex: flashquiz)

```bash
# Extraire le module
docker cp wims:/home/wims/public_html/modules/adm/class/flashquiz <votre-dossier>/flashquiz

# Ajouter le volume au docker run
-v <votre-dossier>/flashquiz:/home/wims/public_html/modules/adm/class/flashquiz

# Relancer le conteneur
```

## Licence

- WIMS : GNU GPL
