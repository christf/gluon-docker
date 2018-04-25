FROM gcc:7.2

ENV FFMD_REPO=https://github.com/FreifunkMD/site-ffmd.git
ENV FFMD_VERSION=tags/v0.38-beta.1
ENV GLUON_VERSION=origin/v2016.2.x

# Update & install packages & cleanup afterwards
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install \
        build-essential \
        gawk \
        git \
        libncurses-dev \
        libssl-dev \
        libz-dev \
        python-pip \
        python3-pip \
        subversion \
        unzip \
        wget && \
    apt-get clean autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

RUN git clone git://github.com/freifunk-gluon/gluon.git 
WORKDIR gluon
RUN git checkout $GLUON_VERSION

# COPY profiles.mk /gluon/targets/ar71xx-generic/profiles.mk
COPY buildOnly.sh buildOnly.sh


RUN git clone $FFMD_REPO site
WORKDIR site
RUN git checkout $FFMD_VERSION

WORKDIR /gluon
RUN pwd

# RUN make update

ENV FORCE_UNSAFE_CONFIGURE=1

ENTRYPOINT ["/bin/bash"]
# CMD ["./site/build.sh", "-v"] 
