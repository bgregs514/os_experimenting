; ensures that we jump straight into the kernel's entry function
[bits 32]	; 32 bit since we're in protected mode
[extern main]	; declare that we will be referencing the external symbol "main"; the linker
		; will substitute the address

call main	; invoke main() in our C kernel
jmp $		; hang
