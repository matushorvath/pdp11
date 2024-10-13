# hadolint global ignore=DL3008

####################
# Build Open SimH
FROM debian:12.7-slim AS build-pdp11

RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential cmake cmake-data \
        libedit2 libedit-dev libpcre3 libpcre3-dev pkg-config zlib1g zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/simh

ADD https://github.com/open-simh/simh.git#36605c4950faf0c3a01f3d24040dfb5519bc0ae3 .
RUN cmake/cmake-builder.sh --flavor unix --target pdp11 --novideo --notest

####################
# DEC PDP11 on Open SimH
FROM gcr.io/distroless/base-nossl-debian12:nonroot AS pdp11

WORKDIR /opt/pdp11

COPY --from=build-pdp11 /lib/x86_64-linux-gnu/libpcre.so.3 /lib/x86_64-linux-gnu/
COPY --from=build-pdp11 /lib/x86_64-linux-gnu/libedit.so.2 /lib/x86_64-linux-gnu/
COPY --from=build-pdp11 /lib/x86_64-linux-gnu/libtinfo.so.6 /lib/x86_64-linux-gnu/
COPY --from=build-pdp11 /lib/x86_64-linux-gnu/libbsd.so.0 /lib/x86_64-linux-gnu/
COPY --from=build-pdp11 /lib/x86_64-linux-gnu/libmd.so.0 /lib/x86_64-linux-gnu/

COPY --from=build-pdp11 /usr/src/simh/BIN/pdp11 .

ENTRYPOINT ["./pdp11"]

####################
# Prepare data tapes
FROM debian:12.7-slim AS tapes

WORKDIR /tapes

ADD https://www.tuhs.org/Archive/Distributions/UCB/2.11BSD-patch481/2.11BSD-481-simh-dist.tap 2.11bsd.tap
ADD https://www.tuhs.org/Archive/Distributions/UCB/2.11BSD/Patches/482 482.txt

COPY data/Makefile.patch 2.11bsd-data/
COPY data/SIMH 2.11bsd-data/
COPY data/fstab 2.11bsd-data/
COPY data/rc.patch 2.11bsd-data/

ADD https://github.com/AaronJackson/2.11BSDhttpd.git#6ee71e5ed2a462f492543b372df3d631d70afd26 httpd-data/httpd
COPY data/index.html httpd-data/

RUN sed -n '89,182p' < 482.txt > 2.11bsd-data/482.sh \
    && sed -n '205,$p' < 482.txt > 2.11bsd-data/482.patch \
    && chmod a+x 2.11bsd-data/482.sh \
    && tar cvf 2.11bsd-data.tar 2.11bsd-data \
    && tar cvf httpd-data.tar httpd-data \
    && rm -rf 2.11bsd-data httpd-data

####################
# Load 2.11BSD root file system from tape
FROM pdp11 AS build-pdp11-2.11bsd-tape

WORKDIR /opt/pdp11

COPY simh/install-tape.ini .
COPY --chown=nonroot:nonroot --from=tapes /tapes/2.11bsd.tap .

RUN ["./pdp11", "install-tape.ini"]

####################
# Load rest of the file system from tape
FROM pdp11 AS build-pdp11-2.11bsd-file-system

WORKDIR /opt/pdp11

COPY simh/install-file-system.ini .
COPY --chown=nonroot:nonroot --from=tapes /tapes/2.11bsd.tap .
COPY --from=tapes /tapes/2.11bsd-data.tar .
COPY --chown=nonroot:nonroot --from=build-pdp11-2.11bsd-tape /opt/pdp11/rq0.dsk .

RUN ["./pdp11", "install-file-system.ini"]

####################
# Rebuild the system
FROM pdp11 AS build-pdp11-2.11bsd-rebuild

WORKDIR /opt/pdp11

COPY simh/install-rebuild.ini .
COPY --from=tapes /tapes/2.11bsd-data.tar .
COPY --chown=nonroot:nonroot --from=build-pdp11-2.11bsd-file-system /opt/pdp11/rq0.dsk .

RUN ["./pdp11", "install-rebuild.ini"]

####################
# Configure the system
FROM pdp11 AS build-pdp11-2.11bsd-config

WORKDIR /opt/pdp11

COPY simh/install-config.ini .
COPY --chown=nonroot:nonroot --from=build-pdp11-2.11bsd-rebuild /opt/pdp11/rq0.dsk .

RUN ["./pdp11", "install-config.ini"]

####################
# DEC PDP11 with 2.11BSD on Open SimH
FROM pdp11 AS pdp11-2.11bsd

WORKDIR /opt/pdp11

COPY simh/run.ini .
COPY --chown=nonroot:nonroot --from=build-pdp11-2.11bsd-config /opt/pdp11/rq0.dsk .

ENTRYPOINT ["./pdp11", "run.ini"]

####################
# Install and configure httpd
FROM pdp11 AS build-pdp11-2.11bsd-httpd

WORKDIR /opt/pdp11

COPY simh/install-httpd.ini .
COPY --from=tapes /tapes/httpd-data.tar .
COPY --chown=nonroot:nonroot --from=build-pdp11-2.11bsd-config /opt/pdp11/rq0.dsk .

RUN ["./pdp11", "install-httpd.ini"]

####################
# DEC PDP11 with 2.11BSD and httpd on Open SimH
FROM pdp11 AS pdp11-2.11bsd-httpd

EXPOSE 80/tcp

ARG BUSYBOX_VERSION=1.35.0-x86_64-linux-musl
ADD --chmod=755 https://busybox.net/downloads/binaries/$BUSYBOX_VERSION/busybox_WGET /usr/bin/wget

HEALTHCHECK --interval=30s --timeout=3s \
    CMD ["/usr/bin/wget", "--no-verbose", "--tries=1", "--spider", "http://localhost/"]

WORKDIR /opt/pdp11

COPY simh/run.ini .
COPY --chown=nonroot:nonroot --from=build-pdp11-2.11bsd-httpd /opt/pdp11/rq0.dsk .

ENTRYPOINT ["./pdp11", "run.ini"]
