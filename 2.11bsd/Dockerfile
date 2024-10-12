####################
# Build Open SimH
FROM debian:12.7-slim AS build-simh

RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential cmake cmake-data \
        libedit2 libedit-dev libpcre3 libpcre3-dev pkg-config zlib1g zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/simh

ADD https://github.com/open-simh/simh.git#36605c4950faf0c3a01f3d24040dfb5519bc0ae3 .
RUN cmake/cmake-builder.sh --flavor unix --target pdp11 --novideo --notest

####################
# Prepare data
FROM debian:12.7-slim AS prepare-data

WORKDIR /data

ADD https://www.tuhs.org/Archive/Distributions/UCB/2.11BSD-patch481/2.11BSD-481-simh-dist.tap 2.11bsd.tap

ADD https://www.tuhs.org/Archive/Distributions/UCB/2.11BSD/Patches/482 482.txt
RUN mkdir -p patch \
    && sed -n '89,182p' < 482.txt > patch/482.sh \
    && sed -n '205,$p' < 482.txt > patch/482.patch \
    && chmod a+x patch/482.sh \
    && tar cvf patch.tar patch \
    && rm -rf patch

ADD https://github.com/AaronJackson/2.11BSDhttpd.git#6ee71e5ed2a462f492543b372df3d631d70afd26 httpd
RUN tar cvf httpd.tar httpd && rm -rf httpd

COPY data/Makefile.patch misc/
COPY data/SIMH misc/
COPY data/fstab misc/
COPY data/index.html misc/
COPY data/rc.patch misc/
RUN tar -cvf misc.tar misc && rm -rf misc

ARG BUSYBOX_VERSION=1.35.0-x86_64-linux-musl
ADD --chmod=755 https://busybox.net/downloads/binaries/$BUSYBOX_VERSION/busybox_WGET wget

####################
# Base image for Open SimH
FROM gcr.io/distroless/base-nossl-debian12:nonroot AS base

WORKDIR /opt/pdp11

COPY --from=build-simh /lib/x86_64-linux-gnu/libpcre.so.3 /lib/x86_64-linux-gnu/
COPY --from=build-simh /lib/x86_64-linux-gnu/libedit.so.2 /lib/x86_64-linux-gnu/
COPY --from=build-simh /lib/x86_64-linux-gnu/libtinfo.so.6 /lib/x86_64-linux-gnu/
COPY --from=build-simh /lib/x86_64-linux-gnu/libbsd.so.0 /lib/x86_64-linux-gnu/
COPY --from=build-simh /lib/x86_64-linux-gnu/libmd.so.0 /lib/x86_64-linux-gnu/

COPY --from=build-simh /usr/src/simh/BIN/pdp11 .

####################
# Load 2.11BSD root file system from tape
FROM base AS install-tape

WORKDIR /opt/pdp11

COPY simh/install-tape.ini .
COPY --chown=nonroot:nonroot --from=prepare-data /data/2.11bsd.tap .

RUN ["./pdp11", "install-tape.ini"]

####################
# Load rest of the file system from tape
FROM base AS install-file-system

WORKDIR /opt/pdp11

COPY simh/install-file-system.ini .
COPY --chown=nonroot:nonroot --from=prepare-data /data/2.11bsd.tap .
COPY --from=prepare-data /data/misc.tar .
COPY --chown=nonroot:nonroot --from=install-tape /opt/pdp11/rq0.dsk .

RUN ["./pdp11", "install-file-system.ini"]

####################
# Rebuild the system
FROM base AS install-rebuild

WORKDIR /opt/pdp11

COPY simh/install-rebuild.ini .
COPY --from=prepare-data /data/misc.tar .
COPY --from=prepare-data /data/patch.tar .
COPY --chown=nonroot:nonroot --from=install-file-system /opt/pdp11/rq0.dsk .

RUN ["./pdp11", "install-rebuild.ini"]

####################
# Configure the system
FROM base AS install-config

WORKDIR /opt/pdp11

COPY simh/install-config.ini .
COPY --chown=nonroot:nonroot --from=install-rebuild /opt/pdp11/rq0.dsk .

RUN ["./pdp11", "install-config.ini"]

####################
# Install and configure httpd
FROM base AS install-httpd

WORKDIR /opt/pdp11

COPY simh/install-httpd.ini .
COPY --from=prepare-data /data/httpd.tar .
COPY --from=prepare-data /data/misc.tar .
COPY --chown=nonroot:nonroot --from=install-config /opt/pdp11/rq0.dsk .

RUN ["./pdp11", "install-httpd.ini"]

####################
# Run 2.11BSD with httpd
FROM base AS run

EXPOSE 80/tcp

COPY --from=prepare-data /data/wget /usr/bin/wget
HEALTHCHECK --interval=30s --timeout=3s \
    CMD ["/usr/bin/wget", "--no-verbose", "--tries=1", "--spider", "http://localhost/"]

WORKDIR /opt/pdp11

COPY simh/run.ini .
COPY --chown=nonroot:nonroot --from=install-httpd /opt/pdp11/rq0.dsk .

ENTRYPOINT ["./pdp11", "run.ini"]
