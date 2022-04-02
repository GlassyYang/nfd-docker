FROM ubuntu:18.04
COPY ./kite-ndn-cxx /home/kite/kite-ndn-cxx
COPY ./kite-NFD /home/kite/kite-NFD
COPY ./kite-ndn-tools /home/kite/kite-ndn-tools
COPY ./*.sh /home/kite/
COPY ./conf /usr/local/etc/ndn
WORKDIR /home/kite
RUN echo "deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse \n\
    deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse \n\
    deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse \n\
    deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse \n\
    deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse \n\
    deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse \n\
    deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse \n\
    deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse \n\
    deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse \n\
    deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse" >/etc/apt/sources.list &&\
    apt update &&\
    apt install -y build-essential pkg-config python3-minimal libboost-all-dev libssl-dev \
    libsqlite3-dev libpcap-dev libsystemd-dev &&\
    cd kite-ndn-cxx &&\
    ./waf configure &&\
    ./waf &&\
    ./waf install &&\
    ldconfig &&\
    cd ../kite-NFD &&\
    ./waf configure &&\
    ./waf &&\
    ./waf install &&\
    cd ../kite-ndn-tools &&\
    ./waf configure &&\
    ./waf &&\
    ./waf install &&\
    ndnsec import -i /usr/local/etc/ndn/rv.safebag -P 1 &&\
    rm -rf /var/cache/debconf/* /var/lib/apt/lists/* /var/log/* /var/tmp/* /tmp/*  &&\
    rm -rf /home/kite/kite-ndn-cxx /home/kite/kite-NFD /home/kite/kite-ndn-tools &&\
    rm /usr/local/etc/ndn/rv.safebag
EXPOSE 6363/tcp 6363/udp 9696/tcp
VOLUME [ "/usr/local/etc/ndn" ]
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 CMD ["/usr/local/bin/nfdc", "status", "report"]
ENTRYPOINT  [ "/home/kite/nfd-start.sh" ]


