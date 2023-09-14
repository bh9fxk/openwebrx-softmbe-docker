FROM debian:bullseye-slim AS build

ARG ARCH
FROM jketterl/openwebrx:latest
LABEL OpenWebRX + Digital codecs (mbelib), using codecserver-softmbe.

ENV S6_CMD_ARG0="/opt/openwebrx/docker/scripts/run.sh"

COPY integrate-softmbe.sh /
RUN /integrate-softmbe.sh

WORKDIR /opt/openwebrx

VOLUME /etc/openwebrx
VOLUME /var/lib/openwebrx

# CMD []

EXPOSE 8073
