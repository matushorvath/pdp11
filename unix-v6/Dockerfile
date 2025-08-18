####################
# Build Open SimH
FROM debian:13.0-slim AS build-simh

RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential cmake cmake-data \
        libedit2 libedit-dev libpcre2-posix3 libpcre2-dev pkg-config zlib1g zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/simh

ADD https://github.com/open-simh/simh.git#36605c4950faf0c3a01f3d24040dfb5519bc0ae3 .
RUN cmake/cmake-builder.sh --flavor unix --target pdp11 --novideo --nonetwork --notest

####################
# Run
FROM gcr.io/distroless/base-nossl-debian12:nonroot

WORKDIR /opt/pdp11

COPY --from=build-simh /lib/x86_64-linux-gnu/libpcre2-posix.so.3 /lib/x86_64-linux-gnu/
COPY --from=build-simh /lib/x86_64-linux-gnu/libedit.so.2 /lib/x86_64-linux-gnu/
COPY --from=build-simh /lib/x86_64-linux-gnu/libtinfo.so.6 /lib/x86_64-linux-gnu/
COPY --from=build-simh /lib/x86_64-linux-gnu/libbsd.so.0 /lib/x86_64-linux-gnu/
COPY --from=build-simh /lib/x86_64-linux-gnu/libmd.so.0 /lib/x86_64-linux-gnu/

COPY --from=build-simh /usr/src/simh/BIN/pdp11 .

COPY simh.ini .
ADD --chown=nonroot:nonroot https://www.tuhs.org/Archive/Distributions/Other/OS_Course/v6/dist.tap .

ENTRYPOINT ["./pdp11"]
