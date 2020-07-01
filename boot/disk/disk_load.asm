disk_load:
	push dx

	mov ah, 0x02	; BIOS read sector function
	mov al, dh	; read dh sectors
	mov ch, 0x00	; select cylinder 0
	mov dh, 0x00	; select head 0
	mov cl, 0x02	; start reading from second sector (after the boot sector)

	int 0x13	; BIOS interrupt

	jc disk_error	; jump if error (if carry flag is set)

	pop dx
	cmp dh, al	; if al (actual sectors read) != dh (expected sectors read), error
	jne disk_error2
	ret

disk_error:
	mov bx, DISK_ERROR_MSG
	call print
	jmp $

disk_error2:
	mov bx, DISK_ERROR_MSG2
	call print
	jmp $

DISK_ERROR_MSG: db "Disk read error: carry flag!", 0
DISK_ERROR_MSG2: db "Disk read error: not all sectors read!", 0
