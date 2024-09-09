FROM debian:bullseye as builder

RUN apt update \
    && apt install -y build-essential

ADD . .

RUN make

# ---------- 8< ----------

FROM bitnami/minideb:bullseye

ENV CFG_FILE=/etc/predixy/predixy.conf
ENV LOG_PATH=/var/log/predixy
ENV TAIL_NUM=20

RUN mkdir -p /etc/predixy /var/log/predixy

WORKDIR /etc/predixy/

COPY --from=redis:7.0.2 /usr/local/bin/redis-cli /usr/bin/redis-cli
COPY --from=builder /checkerror.sh /usr/bin/checkerror.sh
COPY --from=builder /entrypoint.sh /usr/bin/entrypoint.sh
COPY --from=builder /src/predixy /usr/bin/predixy

VOLUME ["/etc/predixy", "/var/log/predixy"]

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
