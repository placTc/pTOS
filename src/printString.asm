printNullTerminatedString:
	push bp
	mov bp, sp
	pusha
	mov si, [bp+4]
printNullTerminatedString_loop:
	mov ah, 0x0E
	mov al, [si]
	cmp al, 0
	je printNullTerminatedString_end
	mov bx, 0x000F
	int 0x10
	inc si
	jmp printNullTerminatedString_loop
printNullTerminatedString_end:
	popa
	mov sp, bp
	pop bp
	ret 2


printChar:
	push bp
	mov bp, sp
	mov al, [bp+4]
	mov ah, 0x0E
	int 0x10
	mov sp, bp
	pop bp
	ret 2