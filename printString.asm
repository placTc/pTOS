printNullTerminatedString:
	pusha
printNullTerminatedString_loop:
	mov ah, 0x0E
	mov al, [bx]
	cmp al, 0
	je printNullTerminatedString_end
	push bx
	mov bx, 0x000F
	int 0x10
	pop bx
	inc bx
	jmp printNullTerminatedString_loop
printNullTerminatedString_end:
	popa
	ret

printCharFromAL:
	mov ah, 0x0E
	int 0x10
	ret