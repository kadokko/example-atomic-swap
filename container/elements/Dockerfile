FROM ubuntu:bionic

ENV DEBCONF_NOWARNINGS yes
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update  -y \
&&  apt-get upgrade -y \
&&  apt-get clean
 
RUN apt-get update  -y \
&&  apt-get install -y \
    git                \
    build-essential    \
    libtool            \
    autotools-dev      \
    automake           \
    pkg-config         \
    libssl-dev         \
    libevent-dev       \
    bsdmainutils       \
    python3            \
    libboost-all-dev   \
    libgmp-dev         \
    gmp-doc            \
&&  apt-get clean

RUN apt-get install -y \
    software-properties-common \
&&  add-apt-repository ppa:bitcoin/bitcoin \
&&  apt-get update  -y \
&&  apt-get install -y \
    libdb4.8-dev       \
    libdb4.8++-dev     \
&&  apt-get clean

ARG ELEMENTS_VER
ARG ELEMENTS_CONF_DIR
ARG CONFIGURE_OPT

RUN git clone https://github.com/ElementsProject/elements.git -b elements-${ELEMENTS_VER} --depth 1 \
&&  cd elements \
&&  ./autogen.sh \
&&  ./configure ${CONFIGURE_OPT} \
&&  make \
&&  make install

RUN groupadd elements \
&&  useradd -g elements -s /bin/false elements \
&&  mkdir -p ${ELEMENTS_CONF_DIR}

ADD conf/elements.conf ${ELEMENTS_CONF_DIR}/.
RUN chown -R elements:elements ${ELEMENTS_CONF_DIR}

RUN apt-get install -y \
    jq                 \
    wget               \
    curl               \
    tar                \
    unzip              \
    sudo               \
    iputils-ping       \
    net-tools          \
&&  apt-get clean

USER elements

EXPOSE 18443

CMD ["tail", "-f", "/dev/null"]
