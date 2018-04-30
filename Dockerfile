FROM ubuntu:16.04

# docker build -t vanessa/os .
# docker run -it vanessa/os bash

########################################

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y nasm qemu ghex
RUN mkdir -p /code
ADD . /code

RUN apt-get clean          # tests, mysql,  postgres

# 1. Create bootsector

RUN mkdir -p /rootfs/boot
RUN cp /code/boot/* /rootfs/boot && \
    nasm -f bin /rootfs/boot/boot_sect_simple.asm -o /rootfs/boot/boot_sect_simple.bin && \
    alias qemu='qemu-system-x86_64'
    # qemu /rootfs/boot/boot_sect_simple.bin -curses
    # see img/1-create-boot.png
