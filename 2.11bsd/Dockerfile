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

COPY 2.11bsd.tap .
COPY inst-1.ini .

COPY --from=build /usr/src/simh/BIN/pdp11 .

RUN ./pdp11 inst-1.ini
#CMD ["./pdp11", "inst-1.ini"]

# Install stage 2
FROM base AS inst-2

RUN mkdir -p /opt/pdp11
WORKDIR /opt/pdp11

COPY 2.11bsd.tap .
COPY inst-2.ini .

COPY --from=build /usr/src/simh/BIN/pdp11 .
COPY --from=inst-1 /opt/pdp11/rq0.dsk .

CMD ["./pdp11", "inst-2.ini"]

# Run
# FROM base

# RUN mkdir -p /opt/pdp11
# WORKDIR /opt/pdp11

# COPY run.ini .

# COPY --from=build /usr/src/simh/BIN/pdp11 .
# COPY --from=inst-1 /opt/pdp11/rq0.dsk .

# CMD ["./pdp11", "run.ini"]
