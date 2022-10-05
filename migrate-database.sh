#!/bin/sh
set -e
export $(grep -v '^#' ../../../compose/conf/.env | xargs)
export $(grep -v '^#' ${ENV_DIR:-swarm-envs}/swarm/wikijs-stack/postgres.env | xargs)

echo backup from source db.
docker run -e PGPASSWORD=${POSTGRES_PASSWORD} \
    --rm \
    --name postgres-client \
    --network shared-services_shared-services \
    --volume "/volume1/docker/backups:/backups" \
    docker-hub.cynicsoft.net/postgres-client:latest \
    /bin/sh -c 'pg_dump -c -h postgres -U postgres wikijs > /backups/data/postgres/wikijs_postgres_backup_manual.dump'

echo restore to target db.
docker run -e PGPASSWORD=${POSTGRES_PASSWORD} \
    --rm \
    --name postgres-client \
    --network wikijs-swarm_default \
    --volume "/volume1/docker/backups:/backups" \
    docker-hub.cynicsoft.net/postgres-client:latest \
    /bin/sh -c 'psql -h postgres -U postgres -d wikijs -f /backups/data/postgres/wikijs_postgres_backup_manual.dump'