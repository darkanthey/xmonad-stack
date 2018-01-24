FROM fedora:latest

RUN yum install -y \
    perl \
    make \
    automake \
    gcc \
    llvm-3.9 \
    curl \
    libffi-devel \
    libXpm-devel \
    libXrandr-devel \
    libXft-devel \
    libXinerama-devel \
    gmp-devel \
    libxml2-devel


ENV PATH "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
RUN curl -sSL https://get.haskellstack.org/ | sh && \
    stack upgrade

