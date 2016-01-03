FROM alpine:3.3

# Run every night by default
ENV SCHEDULE "@daily"
ENV PGUSER postgres
ENV COMPRESSION_LEVEL 9
ENV NAME_PREFIX 'database-archive'
ENV AWS_ENDPOINT 's3.amazonaws.com'

RUN apk --no-cache add --virtual build-dependencies tar postgresql ca-certificates && \
    apk --no-cache add libpq && \

    # s3gof3r for S3 uploads
    wget -qO- https://github.com/rlmcpherson/s3gof3r/releases/download/v0.5.0/gof3r_0.5.0_linux_amd64.tar.gz | tar xvz --strip 1 -C /usr/local/bin/ && \

    # Go based cron replacement
    wget -qO- https://github.com/odise/go-cron/releases/download/v0.0.7/go-cron-linux.gz | zcat > /usr/local/bin/go-cron && \

    # Keep only pg_dump/pg_dumpall
    cp /usr/bin/pg_dump* /usr/local/bin/ && \

    # Cleanup
    apk del build-dependencies

COPY backup.sh /app/backup.sh

RUN chmod +x /app/backup.sh && \
    chmod u+x /usr/local/bin/pg_dump* /usr/local/bin/go-cron /usr/local/bin/gof3r

CMD ["sh", "-c", "go-cron -s \"${SCHEDULE}\" -- sh /app/backup.sh"]
