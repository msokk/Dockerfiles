#!/bin/sh
set -e

export PGHOST=${PGHOST:-$POSTGRES_PORT_5432_TCP_ADDR}
export PGPORT=${PGPORT:-$POSTGRES_PORT_5432_TCP_PORT}

# Required variables
: ${PGHOST:?"--link or hostname to a PostgreSQL container or server is not set"}
: ${PGPORT:?"--link or port to a PostgreSQL container or server is not set"}
: ${AWS_ACCESS_KEY_ID:?"AWS_ACCESS_KEY_ID not specified"}
: ${AWS_SECRET_ACCESS_KEY:?"AWS_SECRET_ACCESS_KEY not specified"}
: ${AWS_BUCKET:?"AWS_BUCKET not specified"}

# Use pg_dump if database name is specified
[ -z "$PGDATABASE" ] && CMD=pg_dumpall || CMD=pg_dump
# Use password authentication if a password is set
[ ! -z "$PGPASSWORD" ] && CMD="${CMD} --password"
# Add database name as suffix to name
[ ! -z "$PGDATABASE" ] && NAME_PREFIX="${NAME_PREFIX}_${PGDATABASE}"

BACKUP="${NAME_PREFIX}_`date +"%Y-%m-%d_%H-%M"`.psql.gz"

echo "Starting database backup to ${AWS_BUCKET}/${BACKUP}"
$CMD | gzip -c${COMPRESSION_LEVEL} | gof3r put -b $AWS_BUCKET -k $BACKUP --endpoint $AWS_ENDPOINT
echo "Backup finished!"
