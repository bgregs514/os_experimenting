print:
	pusha		; store current register values to stack

start:
	mov al, [bx]	; bx = string location
	cmp al, 0
	je done

			; print individual characters
	mov ah, 0x0e	; tty mode
	int 0x10	; interrupt

			; increment pointer and go until a 0 (terminating character) is encountered
	add bx, 1
	jmp start

done:
	popa		; return register values to their initial state
	ret

print_nl:
	pusha
	mov ah, 0x0e
	mov al, 0x0a	; newline character
	int 0x10
	mov al, 0x0d	; carriage return
	int 0x10

	popa
	ret
