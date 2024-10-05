FROM debian:12.7-slim AS base

RUN apt update -y
RUN apt install -y libpcre3 libedit2 libpcap0.8 libvdeplug2


# Build open-simh
FROM base AS build

RUN apt install -y build-essential git cmake cmake-data sudo
RUN apt install -y pkg-config libpcre3-dev libedit-dev libpcap-dev libvdeplug-dev

WORKDIR /usr/src
RUN git clone https://github.com/open-simh/simh.git

WORKDIR /usr/src/simh
RUN git checkout 36605c4950faf0c3a01f3d24040dfb5519bc0ae3
RUN cmake/cmake-builder.sh --flavor unix --target pdp11 --novideo


# Prepare data
FROM base AS prepare-data

RUN apt install -y git curl

RUN mkdir -p /data
WORKDIR /data

# 2.11BSD install tape
RUN curl -sS -o 2.11bsd.tap https://www.tuhs.org/Archive/Distributions/UCB/2.11BSD-patch481/2.11BSD-481-simh-dist.tap

# httpd
RUN git clone https://github.com/AaronJackson/2.11BSDhttpd.git httpd
RUN git -C httpd checkout 6ee71e5ed2a462f492543b372df3d631d70afd26

RUN tar cvf httpd.tar httpd
RUN rm -rf httpd

# misc data
RUN mkdir -p /data/misc

COPY data/Makefile.patch misc
COPY data/SIMH misc
COPY data/fstab misc
COPY data/index.html misc
COPY data/rc.patch misc

RUN tar -cvf misc.tar misc
RUN rm -rf httpd


# Install stage 1
FROM base AS install-1-tape

RUN mkdir -p /opt/pdp11
WORKDIR /opt/pdp11

COPY simh/install-1-tape.ini .
COPY --from=prepare-data /data/2.11bsd.tap .
COPY --from=build /usr/src/simh/BIN/pdp11 .

RUN ./pdp11 install-1-tape.ini


# Install stage 2
FROM base AS install-2-file-system

RUN mkdir -p /opt/pdp11
WORKDIR /opt/pdp11

COPY simh/install-2-file-system.ini .
COPY --from=prepare-data /data/2.11bsd.tap .
COPY --from=prepare-data /data/misc.tar .
COPY --from=build /usr/src/simh/BIN/pdp11 .
COPY --from=install-1-tape /opt/pdp11/rq0.dsk .

RUN ./pdp11 install-2-file-system.ini


# Install stage 3
FROM base AS install-3-kernel

RUN mkdir -p /opt/pdp11
WORKDIR /opt/pdp11

COPY simh/install-3-kernel.ini .
COPY --from=prepare-data /data/misc.tar .
COPY --from=build /usr/src/simh/BIN/pdp11 .
COPY --from=install-2-file-system /opt/pdp11/rq0.dsk .

RUN ./pdp11 install-3-kernel.ini


# Install stage 4
FROM base AS install-4-config

RUN mkdir -p /opt/pdp11
WORKDIR /opt/pdp11

COPY simh/install-4-config.ini .
COPY --from=build /usr/src/simh/BIN/pdp11 .
COPY --from=install-3-kernel /opt/pdp11/rq0.dsk .

RUN ./pdp11 install-4-config.ini


# Install stage 5
FROM base AS install-5-httpd

RUN apt install -y build-essential git

RUN mkdir -p /opt/pdp11
WORKDIR /opt/pdp11

COPY simh/install-5-httpd.ini .
COPY --from=prepare-data /data/httpd.tar .
COPY --from=prepare-data /data/misc.tar .
COPY --from=build /usr/src/simh/BIN/pdp11 .
COPY --from=install-4-config /opt/pdp11/rq0.dsk .

RUN ./pdp11 install-5-httpd.ini


# Run
FROM base AS run

RUN mkdir -p /opt/pdp11
WORKDIR /opt/pdp11

COPY simh/run.ini .

COPY --from=build /usr/src/simh/BIN/pdp11 .
COPY --from=install-5-httpd /opt/pdp11/rq0.dsk .

CMD ["./pdp11", "run.ini"]
