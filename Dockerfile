FROM ubuntu:16.04

# docker build -t vanessa/os .
# docker run -it --entrypoint bash vanessa/os
# docker run --it vanessa/os

########################################

ENV DEBIAN_FRONTEND noninteractive
ENV PREFIX="/usr/local/i386elfgcc"
ENV PATH="$PREFIX/bin:$PATH"

RUN mkdir -p /code
ADD . /code

# 1. Install dependencies

RUN apt-get update && apt-get install -y nasm qemu ghex g++ gcc

RUN /bin/bash /code/install_deps.sh

# 2. Create bootsector

RUN mkdir -p /rootfs/boot
WORKDIR /rootfs/boot
RUN echo "\nPreparing Boot Sector..." && \
    cp /code/boot/*asm /rootfs/boot && \
    nasm -f bin /rootfs/boot/main.asm -o /rootfs/boot/boot.bin 
    # This is how to look at binary
    # xxd /rootfs/boot/boot.bin

    # This is how to run
    # qemu-system-x86_64 /rootfs/boot/boot.bin -curses
    # see img/1-create-boot.png

RUN echo "\nCompiling kernel..." && \
    /usr/local/i386elfgcc/bin/i386-elf-gcc -ffreestanding -c /code/kernel/kernel.c -o /code/kernel/kernel.o && \
    nasm /code/kernel/kernel_entry.asm -f elf -o /code/kernel/kernel_entry.o && \ 
    i386-elf-ld -o /rootfs/boot/kernel.bin -Ttext 0x1000 /code/kernel/kernel_entry.o /code/kernel/kernel.o --oformat binary && \
    cat /rootfs/boot/boot.bin /rootfs/boot/kernel.bin > /rootfs/boot/os-image.bin

RUN apt-get clean

ENTRYPOINT ["qemu-system-i386", "-fda", "/rootfs/boot/os-image.bin", "-curses"]
