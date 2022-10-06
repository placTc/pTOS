;Bootable assembly program that will write keyboard input onto the screen

org 0x7C00

beginning: jmp start

_newline: db 0x0A, 0x0D, 0
_startMessage: db "pTboot v(test061022)", 0x0A, 0x0D, 0
_startMessage2: db  "Starting keyboard input", 0x0A, 0x0D, 0x0A, 0x0D, 0
_loadDisc1: db "Loading drive ", 0
_bootDrive: db 0
_asciiIntegerOffset: db 0x30

start:
	mov bx, _startMessage
	call printNullTerminatedString
	mov bx, _loadDisc1
	call printNullTerminatedString
	mov al, [_bootDrive]
	add al, [_asciiIntegerOffset]
	call printCharFromAL
	mov bx, _newline
	call printNullTerminatedString

	; -- The fetus of operating system bootstrapping --
	mov dl, [_bootDrive] 	; From the boot drive
	mov dh, 0x02 			; load two sectors
	xor bx, bx
	mov es, bx
	mov bx, 0x7E00 			; to address [es:bx] == [0x0000:0x9000]
	call loadDrive

	mov al, [0x7E50] ; check first sector data (should be M)
	call printCharFromAL
	mov al, [0x8100] ; check second sector data (should be T)
	call printCharFromAL

	mov bx, _newline
	call printNullTerminatedString
	mov bx, _startMessage2
	call printNullTerminatedString

	;jmp read ; begin reading keyboard inputs (temporary feture, will be removed)
	jmp outside

read:
	mov ax, 0x0000
	int 0x16
	jmp write

write:
	mov ah, 0x0E
	mov bx, 0x000F
	int 0x10
	jmp read

; including the other pieces of code
%include "printString.asm" 
%include "loadDrive.asm"

times 0x200 - 2 - ($ - $$)  db 0
dw 0xAA55

; code outside the boot sector

_test: db "Test", 0
outside:
	mov bx, _test
	call printNullTerminatedString
	mov bx, _newline
	call printNullTerminatedString
	jmp read

; two sectors for testing data loading outside of the boot sector
times 0x400 - ($ - $$) db 0x30  ; 0
times 0x200 db 0x54	 ; T