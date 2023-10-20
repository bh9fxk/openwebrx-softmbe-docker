#FROM jketterl/openwebrx:latest
FROM jketterl/openwebrx:stable

LABEL OpenWebRX + Digital codecs (mbelib), using codecserver-softmbe.


COPY integrate-softmbe-stable.sh /
RUN / integrate-softmbe-stable.sh
