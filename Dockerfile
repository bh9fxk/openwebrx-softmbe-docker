FROM jketterl/openwebrx:latest-armv7l
LABEL OpenWebRX + Digital codecs (mbelib), using codecserver-softmbe.


COPY integrate-softmbe.sh /
RUN /integrate-softmbe.sh
