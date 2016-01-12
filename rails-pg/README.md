# rails-pg
[![Docker Hub](https://img.shields.io/badge/docker-ready-blue.svg)](https://registry.hub.docker.com/u/msokk/rails-pg/)

Onbuild image for Rails 3/4.x on Ruby 2.2.4 with PostgreSQL 9.4 client library.
Compiles assets in the end.

Based on [Alpine Linux](https://hub.docker.com/_/alpine/).



#### Environment variables

* `RAILS_ENV/RACK_ENV` - Environment to run in (default: `production`)