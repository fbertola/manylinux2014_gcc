FROM quay.io/pypa/manylinux2014_x86_64

LABEL description="A custom Manylinx2014 image with GCC 5.5 made to build Cppyy Python wheels."

ARG GCC_VERSION=5.5.0
ARG GCC_PATH=/usr/local/gcc-$GCC_VERSION

RUN yum -y update && yum -y install \
    wget \
    curl \
    bison \
    flex \
    && yum clean all

RUN cd /tmp \
    && curl -L -o gcc.tar.gz "https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.gz" \
    && tar xf gcc.tar.gz \
    && cd /tmp/gcc-$GCC_VERSION \
    && contrib/download_prerequisites \
    && mkdir build \
    && cd build \
    && ../configure -v \
        --build=x86_64-linux-gnu \
        --host=x86_64-linux-gnu \
        --target=x86_64-linux-gnu \
        --prefix=/usr/local/gcc-$GCC_VERSION \
        --enable-checking=release \
        --enable-languages=c,c++,fortran \
        --disable-multilib \
        --program-suffix=-$GCC_VERSION \
    && make -j4 \
    && make install-strip \
    && cd /tmp \
    && rm -rf /tmp/gcc-$GCC_VERSION /tmp/gcc.tar.gz