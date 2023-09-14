FROM jketterl/openwebrx:latest
MAINTAINER bh9fxk@qq.com
LABEL OpenWebRX + Digital codecs (mbelib), using codecserver-softmbe.


COPY integrate-softmbe.sh /
chmod +x integrate-softmbe.sh /
RUN /integrate-softmbe.sh
