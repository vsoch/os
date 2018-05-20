FROM vanessa/os-base

# docker build -t vanessa/os .
# docker run -it --entrypoint bash vanessa/os
# docker run --it vanessa/os

########################################

# 1. Install dependencies
# This is done in vanessa/os-base

# 2. Use Makefile to generate

ADD . /code

RUN echo "\nPreparing Dinosaur OS..." && \
    mkdir -p /rootfs/boot && \
    cp -R /code/* /rootfs

WORKDIR /rootfs
RUN make clean && make

RUN apt-get clean

ENTRYPOINT ["qemu-system-i386", "-fda", "/rootfs/os-image.bin", "-curses"]
