FROM ubuntu:xenial

RUN apt-get update && apt-get install -y \
    perl \
    make \
    automake \
    gcc \
    llvm-3.9 \
    curl \        
    libgmp-dev \
    libffi-dev \
    libxpm-dev \
    libxrandr-dev \
    libxft-dev \
    libxml2-dev \
    libxinerama-dev


ENV PATH "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
RUN curl -sSL https://get.haskellstack.org/ | sh && \
    stack upgrade

