# postgres-s3-backup
[![Docker Hub](https://img.shields.io/badge/docker-ready-blue.svg)](https://registry.hub.docker.com/u/msokk/postgres-s3-backup/)

Cron scheduled streaming upload of compressed PostgreSQL database dumps to AWS S3.

Supports linking: `docker run --link postgres:postgres msokk/postgres-s3-backup`

Based on [Alpine Linux](https://hub.docker.com/_/alpine/),
using [s3gof3r](https://github.com/rlmcpherson/s3gof3r/) and [go-cron](https://github.com/odise/go-cron).

#### Environment variables

##### *Required*
* `AWS_ACCESS_KEY_ID` - AWS S3 access key.
* `AWS_SECRET_ACCESS_KEY` - AWS S3 secret key.
* `AWS_BUCKET` - AWS S3 bucket.

##### *Optional*
* `SCHEDULE` - go-cron pattern to define. [See CRON Expression Format](https://godoc.org/github.com/robfig/cron#hdr-CRON_Expression_Format) (default: `@daily`)
* `PGDATABASE` - Specify a database to backup (default: not set, runs `pg_dumpall`)
* `PGHOST/PGPORT` - Two variables which can be set to specify the usage of a different container or PostgreSQL server (meaning you aren't linking). (default: `$POSTGRES_PORT_5432_TCP_{ADDR/PORT}`)
* `PGUSER` - The database user to connect as (default: `postgres`)
* `NAME_PREFIX` - A prefix in front of the date i.e. `jira-data-dir-backup`. Can be prefixed with folder. (default: `database-archive`)
* `COMPRESSION_LEVEL` - The compression level for gzip to use (0-9). (default: `9`)
* `AWS_ENDPOINT` - AWS endpoint to configure, i.e `s3-eu-central-1.amazonaws.com` for Frankfurt (default: `s3.amazonaws.com`).
