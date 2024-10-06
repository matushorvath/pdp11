####################
# Base image
FROM debian:12.7-slim AS base

RUN apt-get update \
    && apt-get install -y --no-install-recommends libedit2 libpcap0.8 libpcre3 libvdeplug2 zlib1g \
    && rm -rf /var/lib/apt/lists/*

####################
# Build Open SimH
FROM base AS build-simh

RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential cmake cmake-data \
        libedit-dev libpcap-dev libpcre3-dev libvdeplug-dev pkg-config zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

USER 1000:1000
WORKDIR /usr/src/simh

ADD --chown=1000:1000 https://github.com/open-simh/simh.git#36605c4950faf0c3a01f3d24040dfb5519bc0ae3 .
RUN cmake/cmake-builder.sh --flavor unix --target pdp11 --novideo

####################
# Prepare data
FROM base AS prepare-data

USER 1000:1000
WORKDIR /data

ADD --chown=1000:1000 https://www.tuhs.org/Archive/Distributions/UCB/2.11BSD-patch481/2.11BSD-481-simh-dist.tap 2.11bsd.tap

ADD --chown=1000:1000 https://github.com/AaronJackson/2.11BSDhttpd.git#6ee71e5ed2a462f492543b372df3d631d70afd26 httpd
RUN tar cvf httpd.tar httpd && rm -rf httpd

COPY --chown=1000:1000 data/Makefile.patch misc/
COPY --chown=1000:1000 data/SIMH misc/
COPY --chown=1000:1000 data/fstab misc/
COPY --chown=1000:1000 data/index.html misc/
COPY --chown=1000:1000 data/rc.patch misc/
RUN tar -cvf misc.tar misc && rm -rf misc

####################
# Install stage 1
FROM base AS install-1-tape

USER 1000:1000
WORKDIR /opt/pdp11

COPY simh/install-1-tape.ini .
COPY --from=prepare-data /data/2.11bsd.tap .
COPY --from=build-simh /usr/src/simh/BIN/pdp11 .

RUN ./pdp11 install-1-tape.ini

####################
# Install stage 2
FROM base AS install-2-file-system

USER 1000:1000
WORKDIR /opt/pdp11

COPY simh/install-2-file-system.ini .
COPY --from=prepare-data /data/2.11bsd.tap .
COPY --from=prepare-data /data/misc.tar .
COPY --from=build-simh /usr/src/simh/BIN/pdp11 .
COPY --from=install-1-tape /opt/pdp11/rq0.dsk .

RUN ./pdp11 install-2-file-system.ini

####################
# Install stage 3
FROM base AS install-3-kernel

USER 1000:1000
WORKDIR /opt/pdp11

COPY simh/install-3-kernel.ini .
COPY --from=prepare-data /data/misc.tar .
COPY --from=build-simh /usr/src/simh/BIN/pdp11 .
COPY --from=install-2-file-system /opt/pdp11/rq0.dsk .

RUN ./pdp11 install-3-kernel.ini

####################
# Install stage 4
FROM base AS install-4-config

USER 1000:1000
WORKDIR /opt/pdp11

COPY simh/install-4-config.ini .
COPY --from=build-simh /usr/src/simh/BIN/pdp11 .
COPY --from=install-3-kernel /opt/pdp11/rq0.dsk .

RUN ./pdp11 install-4-config.ini

####################
# Install stage 5
FROM base AS install-5-httpd

EXPOSE 80/tcp

USER 1000:1000
WORKDIR /opt/pdp11

COPY simh/install-5-httpd.ini .
COPY --from=prepare-data /data/httpd.tar .
COPY --from=prepare-data /data/misc.tar .
COPY --from=build-simh /usr/src/simh/BIN/pdp11 .
COPY --from=install-4-config /opt/pdp11/rq0.dsk .

RUN ./pdp11 install-5-httpd.ini

####################
# Run
FROM base AS run

USER 1000:1000
WORKDIR /opt/pdp11

COPY simh/run.ini .
COPY --from=build-simh /usr/src/simh/BIN/pdp11 .
COPY --from=install-5-httpd /opt/pdp11/rq0.dsk .

CMD ["./pdp11", "run.ini"]
