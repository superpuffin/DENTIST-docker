FROM ubuntu:noble as BUILDER

ENV DEBIAN_FRONTEND=nonintreactive

RUN apt-get update && \
    apt-get install -y \
    build-essential \
    git \
    libboost-all-dev \
    libeigen3-dev \
    libmkl-full-dev \
    libmkl-cluster-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# This fixes all my errors in magic ways I have yet to understand ✨
ENV CPATH="/usr/include/mkl:/usr/include/eigen3:/DENTIST:/DENTIST/main"

ADD Makefile.patch /

RUN git clone --depth 1 https://github.com/Yves-CHEN/DENTIST.git && \
    cd DENTIST && \
    patch Makefile < /Makefile.patch && \
    make

FROM ubuntu:noble

RUN apt-get update && \
    apt-get install -y \
    libboost-all-dev \
    libeigen3-dev \
    libmkl-full-dev \
    libmkl-cluster-dev && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /DENTIST/builts/DENTIST* /usr/bin/DENTIST