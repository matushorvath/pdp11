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
FROM base AS inst-1

RUN mkdir -p /opt/pdp11
WORKDIR /opt/pdp11

COPY simh/inst-1.ini .
COPY 2.11bsd.tap .

COPY --from=build /usr/src/simh/BIN/pdp11 .

RUN ./pdp11 inst-1.ini

# Install stage 2
FROM base AS inst-2

RUN mkdir -p /opt/pdp11
WORKDIR /opt/pdp11

COPY simh/inst-2.ini .
COPY 2.11bsd.tap .
COPY data.tar .

COPY --from=build /usr/src/simh/BIN/pdp11 .
COPY --from=inst-1 /opt/pdp11/rq0.dsk .

RUN ./pdp11 inst-2.ini

# Install stage 3
FROM base AS inst-3

RUN mkdir -p /opt/pdp11
WORKDIR /opt/pdp11

COPY simh/inst-3.ini .
COPY data.tar .

COPY --from=build /usr/src/simh/BIN/pdp11 .
COPY --from=inst-2 /opt/pdp11/rq0.dsk .

RUN ./pdp11 inst-3.ini

# Install stage 4
FROM base AS inst-4

RUN mkdir -p /opt/pdp11
WORKDIR /opt/pdp11

COPY simh/inst-4.ini .

COPY --from=build /usr/src/simh/BIN/pdp11 .
COPY --from=inst-3 /opt/pdp11/rq0.dsk .

RUN ./pdp11 inst-4.ini

# Run
FROM base AS run

RUN mkdir -p /opt/pdp11
WORKDIR /opt/pdp11

COPY simh/run.ini .

COPY --from=build /usr/src/simh/BIN/pdp11 .
COPY --from=inst-4 /opt/pdp11/rq0.dsk .

CMD ["./pdp11", "run.ini"]
