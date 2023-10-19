#FROM jketterl/openwebrx:latest
FROM jketterl/openwebrx:stable

LABEL OpenWebRX + Digital codecs (mbelib), using codecserver-softmbe.


COPY integrate-softmbe.sh /
RUN /integrate-softmbe.sh
