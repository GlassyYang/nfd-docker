# syntax=docker/dockerfile:1
# escape=\
ARG UBUNTU_VERSION=18.04
FROM ubuntu:${UBUNTU_VERSION}
COPY ./ndn-cxx /home/ndn/ndn-cxx
COPY ./NFD /home/ndn/NFD
COPY ./ndn-tools /home/ndn/ndn-tools
COPY ./nfd-start.sh /home/ndn/nfd-start.sh
WORKDIR /home/ndn
RUN apt update &&\
    apt install -y build-essential pkg-config python3-minimal libboost-all-dev libssl-dev \
    libsqlite3-dev libpcap-dev libsystemd-dev &&\
    cd ndn-cxx &&\
    ./waf configure &&\
    ./waf &&\
    ./waf install &&\
    ldconfig &&\
    cd ../NFD &&\
    ./waf configure &&\
    ./waf &&\
    ./waf install &&\
    cd ../ndn-tools &&\
    ./waf configure &&\
    ./waf &&\
    ./waf install &&\
    rm -rf /var/cache/debconf/* /var/lib/apt/lists/* /var/log/* /var/tmp/* /tmp/*  &&\
    rm -rf /home/ndn/ndn-cxx /home/ndn/ndn-tools /home/ndn/NFD 
EXPOSE 6363/tcp 6363/udp 9696/tcp
VOLUME [ "/usr/local/etc/ndn" ]
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 CMD [ "/usr/local/bin/nfdc" "status" "report" ]
ENTRYPOINT  [ "/home/ndn/nfd-start.sh" ]


