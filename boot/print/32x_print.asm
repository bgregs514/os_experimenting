[bits 32]

VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

				; string comes in at ebx
print_string_pm:
	pusha
	mov edx, VIDEO_MEMORY	; set edx to the start of video memory

print_string_pm_loop:
	mov al, [ebx]		; store the char at ebx in al
	mov ah, WHITE_ON_BLACK	; store the attributes in ah

	cmp al, 0		; if al == 0, at the end of the string
	je print_string_pm_done

	mov [edx], ax		; store char and attributes at current character cell
	add ebx, 1		; increment ebx to the next character in the string
	add edx, 2		; move to next character cell in vid memory

	jmp print_string_pm_loop

print_string_pm_done :
	popa
	ret
