# WIMS Docker Dev

Image Docker de WIMS en version développement, construite automatiquement depuis les sources SVN via GitHub Actions.

## Architecture

```
SVN RENATER (sources dev)
        ↓
GitHub (wims-docker-dev)
        ↓ GitHub Actions (build automatique)
Docker Hub (julienlld/wims-dev)
        ↓ docker pull
Machine locale / VPS
```

## Lancer le conteneur

```bash
docker run -d \
  --restart always \
  --security-opt seccomp:unconfined \
  -p 8080:80 \
  -v /home/julien/docker_wims/wims-data:/home/wims/log \
  -v /home/julien/docker_wims/devel:/home/wims/public_html/modules/devel \
  -v /home/julien/docker_wims/flashquiz:/home/wims/public_html/modules/adm/class/flashquiz \
  --name wims \
  julienlld/wims-dev:latest
```

## Volumes persistants

| Dossier local | Dossier conteneur | Contenu |
|---|---|---|
| `docker_wims/wims-data` | `/home/wims/log` | Classes, config, données |
| `docker_wims/devel` | `/home/wims/public_html/modules/devel` | Modules en développement |
| `docker_wims/flashquiz` | `/home/wims/public_html/modules/adm/class/flashquiz` | Module flashquiz |

## Configuration

Le fichier `wims-data/wims.conf` contient la configuration de WIMS :

```
threshold1=1200
threshold2=2400
manager_site=172.17.0.1
```

`manager_site=172.17.0.1` est l'IP du bridge Docker — permet l'accès à l'interface d'administration depuis la machine hôte.

## Variables d'environnement

| Variable | Description | Défaut |
|---|---|---|
| `MANAGER_SITE` | IP autorisée pour l'admin | `172.17.0.1` |
| `WIMS_PASS` | Mot de passe admin | aucun |
| `TZ` | Timezone | UTC |
| `SSMTP_MAILHUB` | Serveur mail relais | aucun |

## Commandes utiles

```bash
# Voir les logs
docker logs wims

# Entrer dans le conteneur
docker exec -it wims /bin/bash

# Récupérer le mot de passe admin
docker exec -it wims cat /home/wims/tmp/log/.wimspassone

# Reconstruire l'index
docker exec -it wims su -s /bin/bash wims -c "cd /home/wims && yes | ./bin/mkindex"

# Arrêter/démarrer
docker stop wims
docker start wims
```

## Mettre à jour l'image

```bash
docker pull julienlld/wims-dev:latest
docker stop wims && docker rm wims
# Relancer avec docker run ...
```

## Builds GitHub Actions

| Workflow | Usage | Cache |
|---|---|---|
| **Build WIMS Dev** | Build normal quotidien | ✅ Oui |
| **Force Rebuild** | Rebuild complet sans cache | ❌ Non |

## Structure du dépôt

```
wims-docker-dev/
├── Dockerfile          ← Image Docker
├── entrypoint.sh       ← Script de démarrage
├── .github/
│   └── workflows/
│       ├── build.yml        ← Build automatique
│       └── build-force.yml  ← Force rebuild
└── wims/               ← Sources WIMS (depuis SVN)
```

## Points importants

- Maxima nécessite `--security-opt seccomp:unconfined`
- WIMS doit être installé dans `/home/wims/` (pas `/home/wims/wims/`)
- Le bridge Docker a toujours l'IP `172.17.0.1`
- Les sources SVN sont dans le dossier `wims/` à la racine du dépôt

## Leçons apprises

- Toujours taguer les images Docker avec un numéro de version
- Tester manuellement dans le conteneur avant de rebuilder
- WIMS cherche ses fichiers relatifs à son répertoire d'installation
- Le volume doit être monté sur `/home/wims/log` et non `/home/wims/wims/log`
- `wimslogd` doit être lancé depuis `public_html` pour trouver les bons chemins
- `manager_site` doit être `172.17.0.1` (IP bridge Docker) et non `127.0.0.1`
