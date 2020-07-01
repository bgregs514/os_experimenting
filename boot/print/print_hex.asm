print_hex:		; receiving data from dx
	pusha

	mov cx, 0	; index variable

hex_loop:
	cmp cx, 4	; loop 4 times for 0x0000
	je end

	mov ax, dx	; copy string to ax (working register)
	and ax, 0x000f	; zero first 3 bytes, keep last
	add al, 0x30	; add 0x30 to convert to ASCII numeric value (0x30 - 0x39)
	cmp al, 0x39	; check to see if we are numeric (<= 0x39) or alpha (> 0x39)
	jle step2
	add al, 7	; alpha = ASCII (0x41 - 0x46), but we are adding decimal, so 'A' (0x41) (65d)
	jmp step2	; = 65 - 58 = 7 * helps to look at the ASCII table

step2:
	mov bx, HEX_OUT + 5
	sub bx, cx
	mov [bx], al
	ror dx, 4

	add cx, 1
	jmp hex_loop

end:
	mov bx, HEX_OUT
	call print

	popa
	ret

HEX_OUT:
	db "0x0000", 0
