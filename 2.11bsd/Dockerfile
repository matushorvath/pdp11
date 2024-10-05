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

# Install stage 1
FROM base AS install-1-tape

RUN mkdir -p /opt/pdp11
WORKDIR /opt/pdp11

COPY simh/install-1-tape.ini .
COPY 2.11bsd.tap .

COPY --from=build /usr/src/simh/BIN/pdp11 .

RUN ./pdp11 install-1-tape.ini

# Install stage 2
FROM base AS install-2-file-system

RUN mkdir -p /opt/pdp11
WORKDIR /opt/pdp11

COPY simh/install-2-file-system.ini .
COPY 2.11bsd.tap .
COPY data.tar .

COPY --from=build /usr/src/simh/BIN/pdp11 .
COPY --from=install-1-tape /opt/pdp11/rq0.dsk .

RUN ./pdp11 install-2-file-system.ini

# Install stage 3
FROM base AS install-3-kernel

RUN mkdir -p /opt/pdp11
WORKDIR /opt/pdp11

COPY simh/install-3-kernel.ini .
COPY data.tar .

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
COPY data.tar .

RUN git clone https://github.com/AaronJackson/2.11BSDhttpd.git httpd

WORKDIR /opt/pdp11/httpd
RUN git checkout 6ee71e5ed2a462f492543b372df3d631d70afd26

WORKDIR /opt/pdp11
RUN tar cvf httpd.tar httpd

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
