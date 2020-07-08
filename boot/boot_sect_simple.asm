; boot sector that boots a C kernel in 32-bit protected mode
[org 0x7c00]
KERNEL_OFFSET equ 0x1000		; this is the memory offset to which we will load our kernel

mov [BOOT_DRIVE], dl			; BIOS stores our boot drive in dl, so it's best to remember this for later

mov bp, 0x9000				; setup the stack
mov sp, bp

mov bx, MSG_REAL_MODE			; log that we are starting in 16 bit real mode
call print
call print_nl

call load_kernel			; load the kernel

call switch_to_pm			; switch to 32 bit protected mode - we will not come back to 16 bit real mode

jmp $

; include routines
%include "print/print_string.asm"
%include "disk/disk_load.asm"
%include "gdt/gdt.asm"
%include "print/32x_print.asm"
%include "gdt/switch_to_pm.asm"

[bits 16]

; load the kernel
load_kernel:
	mov bx, MSG_LOAD_KERNEL		; log that we are loading the kernel
	call print
	call print_nl

	mov bx, KERNEL_OFFSET		; setup parameters for our disk_load routine so that we load the first
	; mov dh, 15			; 15 sectors (excluding the boot sector) from the boot disk (i.e. our
	mov dh, 31
	mov dl, [BOOT_DRIVE]		; kernel code) to address KERNEL_OFFSET
	call disk_load

	ret

[bits 32]
; this is where we arrive after switching to and initializing protected mode

BEGIN_PM:
	mov ebx, MSG_PROT_MODE		; use 32 bit print routine to log that we are in protected mode
	call print_string_pm

	call KERNEL_OFFSET		; now jump to the address of our loaded kernel code - this is the point
					; where the kernel should load

	jmp $				; hang

; global variables
BOOT_DRIVE	db 0
MSG_REAL_MODE	db "Started in 16-bit Real Mode", 0
MSG_PROT_MODE	db "Successfully landed in 32-bit Protected Mode", 0
MSG_LOAD_KERNEL	db "Loading kernel into memory...", 0

; standard boot sector padding
times 510-($-$$) db 0
dw 0xaa55
