[org 0x7c00] ; bootloader offset
KERNEL_OFFSET equ 0x1000 ; The same one we used when linking the kernel

    mov [BOOT_DRIVE], dl ; Remember that the BIOS sets us the boot drive in 'dl' on boot
    mov bp, 0x9000 ; set the stack
    mov sp, bp

    mov bx, DINOSAUR_GREETING
    call print ;
    call print_nl ; This will be written after the BIOS messages

    mov bx, MSG_REAL_MODE
    call print ; 
    call print_nl ;

    call load_kernel ; read the kernel from disk
    call switch_to_pm
    jmp $ ; this will actually never be executed

%include "print.asm"
%include "disk.asm"
%include "gdt.asm"
%include "print-32bit.asm"
%include "switch.asm"

[bits 16]
load_kernel:
    mov bx, MSG_LOAD_KERNEL
    call print
    call print_nl

    mov bx, KERNEL_OFFSET ; Read from disk and store in 0x1000
    mov dh, 2
    mov dl, [BOOT_DRIVE]
    call disk_load
    ret

[bits 32]
; after switch to 32bit, we no longer use BIOS
BEGIN_PM: ; after the switch we will get here
    mov ebx, MSG_PROT_MODE
    call print_string_pm ; Note that this will be written at the top left corner
    call KERNEL_OFFSET ; Give control to the kernel
    jmp $

BOOT_DRIVE        db 0 ; It is a good idea to store it in memory because 'dl' may get overwritten
DINOSAUR_GREETING db "Hello Dinosaur!", 0
MSG_REAL_MODE     db "Started in 16-bit real mode", 0
MSG_PROT_MODE     db "Loaded 32-bit protected mode", 0
MSG_LOAD_KERNEL   db "Loading kernel into memory", 0

; bootsector
times 510-($-$$) db 0
dw 0xaa55
