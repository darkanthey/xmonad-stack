FROM ubuntu:xenial

RUN apt-get update && apt-get install -y \
    perl \
    make \
    automake \
    gcc \
    llvm-5.0 \
    curl \        
    libgmp-dev \
    libffi-dev \
    libxpm-dev \
    libxrandr-dev \
    libxft-dev \
    libxml2-dev \
    libxinerama-dev


ENV PATH "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/.local/bin"

RUN curl -sSL https://get.haskellstack.org/ | sh && stack upgrade

RUN groupadd -r apps -g 1000
RUN useradd -m -d /home/apps -s /bin/bash -r -u 1000 -g 1000 apps

WORKDIR /home/apps
USER apps

ENTRYPOINT /bin/bash build.sh

