[bits 16]
; switch to protected mode
switch_to_pm:
	cli			; we must switch off interrupts until we have set-up the protected mode
				; interrupt vector, otherwise interrupts will crash the system

	lgdt [gdt_descriptor]	; load our global descriptor table, which defines the
				; protected mode segments (code and data)
	
	mov eax, cr0		; to make the switch to protected mode, we set the first bit of cr0,
	or eax, 0x1		; a control register
	mov cr0, eax

	jmp CODE_SEG:init_pm	; make a far jump to our new 32-bit code segment.  this also forces
				; the cpu to flush its cache of pre-fetched and real-mode decoded
				; instructions, which can cause problems

[bits 32]
; initialize registers and the stack once in protected mode
init_pm:
	mov ax, DATA_SEG	; now in protected mode, our old segments are meaningless, so we
	mov ds, ax		; point our segment registers to the data selector we defined
	mov ss, ax		; in our GDT
	mov es, ax
	mov fs, ax
	mov gs, ax

	mov ebp, 0x90000	; update our stack position so it is right at the top of the free space
	mov esp, ebp

	call BEGIN_PM		; finally, call the rest of our code
