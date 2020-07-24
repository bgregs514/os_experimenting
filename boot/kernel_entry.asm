; ensures that we jump straight into the kernel's entry function
global _start;
[bits 32]		; 32 bit since we're in protected mode

_start:
	[extern kernel_main]	; declare that we will be referencing the external symbol "main"; the linker
				; will substitute the address
	call kernel_main	; invoke kernel_main() in our C kernel
	jmp $			; hang
