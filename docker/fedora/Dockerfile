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


ENV PATH "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/.local/bin"

RUN curl -sSL https://get.haskellstack.org/ | sh && stack upgrade

RUN groupadd -r apps -g 1000
RUN useradd -m -d /home/apps -s /bin/bash -r -u 1000 -g 1000 apps

WORKDIR /home/apps
USER apps

ENTRYPOINT /bin/bash build.sh
