FROM ubuntu:16.04

# docker build -t vanessa/os .
# docker run -it vanessa/os bash

########################################

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y nasm qemu ghex
RUN mkdir -p /code
ADD . /code

# 1. Create bootsector

RUN mkdir -p /rootfs/boot
WORKDIR /rootfs/boot
RUN cp /code/boot/*asm /rootfs/boot && \
    nasm -f bin /rootfs/boot/main.asm -o /rootfs/boot/boot.bin 
    # This is how to look at binary
    # xxd /rootfs/boot/boot.bin

    # This is how to run
    # qemu-system-x86_64 /rootfs/boot/boot.bin -curses
    # see img/1-create-boot.png

RUN apt-get clean          # tests, mysql,  postgres

ENTRYPOINT ["qemu-system-x86_64", "/rootfs/boot/boot.bin", "-curses"]
