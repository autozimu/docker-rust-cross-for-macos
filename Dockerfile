FROM debian:jessie

# Install build tools
RUN apt-get update && \
    apt-get install --yes \
        make \
        automake \
        bison \
        curl \
        file \
        flex \
        git \
        libtool \
        pkg-config \
        python \
        texinfo \
        xz-utils \
        vim \
        wget \
        clang

RUN cd /tmp && \
        git clone https://github.com/tpoechtrager/osxcross && \
        cd osxcross && \
        wget https://s3.dockerproject.org/darwin/v2/MacOSX10.11.sdk.tar.xz --directory-prefix=tarballs && \
        sed -i -e 's|-march=native||g' build_clang.sh wrapper/build.sh && \
        UNATTENDED=yes OSX_VERSION_MIN=10.7 ./build.sh
ENV PATH=$PATH:/tmp/osxcross/target/bin

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH=$PATH:~/.cargo/bin
RUN ~/.cargo/bin/rustup target add x86_64-apple-darwin
RUN echo '[target.x86_64-apple-darwin] \n\
linker = "x86_64-apple-darwin15-cc" \n\
ar = "x86_64-apple-darwin15-ar"' >> ~/.cargo/config

CMD /bin/bash
