loadDrive:
	push dx ;DH represents the number of sectors to read, store DX to reference it later

	mov ah, 0x02
	mov al, dh		; read DH sectors
	mov ch, 0x00	; on cylinder 0
	mov dh, 0x00	; from head 0
	mov cl, 0x02	; starting from the second sector
	int 0x13

	jc diskError ; error triggers the carry flag
	pop dx
	cmp dh, al
	jne diskError ; read sectors not equal to instructed amount (NOT ALWAYS TRUE, REPLACE WITH SOMETHING BETTER)
	mov bx, _diskSuccess
	call printNullTerminatedString
	mov bx, _newline
	call printNullTerminatedString
	ret

diskError:
	mov bx , _diskError
	call printNullTerminatedString
	mov bx, _newline
	call printNullTerminatedString
	jmp $

_diskError: db "Disk read error!" , 0
_diskSuccess: db "Success!" , 0

