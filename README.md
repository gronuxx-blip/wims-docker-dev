# WIMS Docker Dev

Image Docker de WIMS en version développement, construite automatiquement depuis les sources SVN via GitHub Actions.

## Architecture

```
SVN RENATER (sources dev)
        ↓
GitHub (wims-docker-dev)
        ↓ GitHub Actions (build automatique)
Docker Hub (<votre-pseudo>/wims-dev)
        ↓ docker pull
Machine locale / VPS
```

## Lancer le conteneur

```bash
docker run -d \
  --restart always \
  --security-opt seccomp:unconfined \
  -p 8080:80 \
  -v <votre-dossier>/wims-data:/home/wims/log \
  -v <votre-dossier>/devel:/home/wims/public_html/modules/devel \
  --name wims \
  <votre-pseudo>/wims-dev:latest
```

## Volumes persistants

| Dossier local | Dossier conteneur | Contenu |
|---|---|---|
| `wims-data` | `/home/wims/log` | Classes, config, données |
| `devel` | `/home/wims/public_html/modules/devel` | Modules en développement |

## Configuration

Le fichier `wims-data/wims.conf` contient la configuration de WIMS :

```
threshold1=<valeur>
threshold2=<valeur>
manager_site=<votre-ip>
```

`manager_site` doit contenir l'IP depuis laquelle vous accédez à l'interface d'administration.

## Variables d'environnement

| Variable | Description | Défaut |
|---|---|---|
| `MANAGER_SITE` | IP autorisée pour l'admin | IP bridge Docker |

## Commandes utiles

```bash
# Voir les logs
docker logs wims

# Entrer dans le conteneur
docker exec -it wims /bin/bash

# Reconstruire l'index
docker exec -it wims su -s /bin/bash wims -c "cd /home/wims && yes | ./bin/mkindex"

# Arrêter/démarrer
docker stop wims
docker start wims
```

## Mettre à jour l'image

```bash
docker pull <votre-pseudo>/wims-dev:latest
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
- WIMS doit être installé dans `/home/wims/`
- Le volume doit être monté sur `/home/wims/log`
- `wimslogd` doit être lancé depuis `public_html`
