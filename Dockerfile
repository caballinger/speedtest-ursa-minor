# syntax=docker/dockerfile:1
FROM alpine
ENV DOWNLOAD_PASS=0
ENV UPLOAD_PASS=0
ENV LATENCY_PASS=10000
ENV SPEEDTEST_SCHEDULE="0 * * * *"
ENV KUMA_ADDR=localhost
ENV KUMA_PORT=3001
ENV DOWNLOAD_KEY=""
ENV UPLOAD_KEY=""
ENV LATENCY_KEY=""

RUN apk add speedtest-cli
RUN apk add curl

COPY app/speedcheck.sh /speedcheck.sh
COPY app/start.sh /start.sh

RUN echo "$SPEEDTEST_SCHEDULE sh /speedcheck.sh" \ 
            "" > /etc/crontabs/root
RUN chmod 755  /speedcheck.sh /start.sh
RUN chmod 0644 /etc/crontabs/root

CMD ["sh", "start.sh"]