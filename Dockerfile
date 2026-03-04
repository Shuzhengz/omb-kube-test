FROM ghcr.io/kastnerrg/qualcomm-docker-base:latest
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    openmpi-bin \
    libopenmpi-dev \
    openssh-client \
    openssh-server \
    && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /var/run/sshd /run/sshd && \
    sed -i 's/#*PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    sed -i 's/#*StrictModes.*/StrictModes no/g' /etc/ssh/sshd_config
WORKDIR /tmp
RUN wget http://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-7.5.2.tar.gz && \
    tar xzf osu-micro-benchmarks-7.5.2.tar.gz && \
    cd osu-micro-benchmarks-7.5.2 && \
    ./configure CC=mpicc CXX=mpicxx --prefix=/usr/local/osu && \
    make -j$(nproc) && \
    make install && \
    rm -rf /tmp/osu-micro-benchmarks*
ENV PATH="/usr/local/osu/libexec/osu-micro-benchmarks/mpi/pt2pt:$PATH"
ENV PATH="/usr/local/osu/libexec/osu-micro-benchmarks/mpi/collective:$PATH"
CMD ["/bin/bash"]
