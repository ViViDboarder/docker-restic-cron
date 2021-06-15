ARG REPO=library
FROM ${REPO}/alpine:3.12

ARG TARGETARCH

RUN apk add --no-cache curl=~7 bash=~5

ARG RCLONE_VERSION=v1.55.1

COPY ./scripts/install_rclone.sh /scripts/
RUN /scripts/install_rclone.sh "$RCLONE_VERSION" "$TARGETARCH"

ARG RESTIC_VERSION=0.12.0

COPY ./scripts/install_restic.sh /scripts/
RUN /scripts/install_restic.sh "$RESTIC_VERSION" "$TARGETARCH"

# Set some default environment variables
ENV BACKUP_DEST="/backups"
ENV BACKUP_NAME="backup"
ENV PATH_TO_BACKUP="/data"
ENV CRON_SCHEDULE=""
ENV VERIFY_CRON_SCHEDULE=""

COPY ./scripts /scripts

HEALTHCHECK CMD /scripts/healthcheck.sh

CMD [ "/scripts/start.sh" ]
