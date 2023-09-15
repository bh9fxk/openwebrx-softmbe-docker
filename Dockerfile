FROM jketterl/openwebrx-full:latest

LABEL OpenWebRX + Digital codecs (mbelib), using codecserver-softmbe.


COPY integrate-softmbe.sh /
RUN /integrate-softmbe.sh
