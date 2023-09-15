FROM alpine:latest
#FROM jketterl/openwebrx:latest

LABEL OpenWebRX + Digital codecs (mbelib), using codecserver-softmbe.


COPY integrate-softmbe.sh /
RUN /integrate-softmbe.sh
