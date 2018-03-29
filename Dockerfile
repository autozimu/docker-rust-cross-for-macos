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
ENV CARGO_TARGET_DIR=/tmp

RUN apt-get install --yes bzip2
RUN curl -L https://github.com/aktau/github-release/releases/download/v0.7.2/linux-amd64-github-release.tar.bz2 | tar -xj && mv bin/linux/amd64/github-release /usr/bin/ && chmod a+x /usr/bin/github-release

CMD /bin/bash
