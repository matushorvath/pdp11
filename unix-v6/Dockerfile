FROM debian:12.7-slim AS base

RUN apt update -y
RUN apt install -y --no-install-recommends libpcre3 libedit2 libpcap0.8 libvdeplug2


FROM base AS build

RUN apt install -y --no-install-recommends build-essential git cmake cmake-data sudo
RUN apt install -y --no-install-recommends pkg-config libpcre3-dev libedit-dev libpcap-dev libvdeplug-dev

WORKDIR /usr/src/simh
ADD https://github.com/open-simh/simh.git#36605c4950faf0c3a01f3d24040dfb5519bc0ae3 .
RUN cmake/cmake-builder.sh --flavor unix --target pdp11 --novideo


FROM base

WORKDIR /opt/pdp11

ADD https://www.tuhs.org/Archive/Distributions/Other/OS_Course/v6/dist.tap .
COPY simh.ini .
COPY --from=build /usr/src/simh/BIN/pdp11 .

CMD ["./pdp11"]
