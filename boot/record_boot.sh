#!/bin/bash

# This is a silly way to capture the output (to the terminal using the qemu 
# emulator) into an asciinema. We start the ascinema, echo some lines, then
# run the emulator. In another window I use "top" to find the process and then
# kill to stop the emulator. Then I can finish up and exit from the asciinema

# Start the asciinema recording
# nasm -f bin boot_sect_simple.asm -o boot_sect_simple.bin
# asciinema rec booty.json
# /bin/bash record_boot.sh

echo "Here we are going to show a quick demo of the bootloader."
sleep 3

echo "The asciinema might cut when it loops continually, and I'm going to try to run it in a subprocess."
sleep 3

echo "It might take me a few seconds to open another terminal and then kill qemu"
sleep 3

# Make an alias for qema, run in subprocess?
(qemu-system-x86_64 boot_sect_simple.bin -curses)
sleep 3
echo "Are we still here? That's it!"
exit
# asciinema upload booty.json
