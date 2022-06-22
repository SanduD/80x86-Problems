;;passing parameter through stack
.MODEL SMALL
.STACK 32
.DATA
RES		DW 0
NUMAR		DW 2
PUTERE		DW 10
TEN_POWER	DW 10000, 1000, 100, 10
StrAfis		DB 0DH, 0AH, 'Rezultat=     $'
.CODE 
START: 
	MOV AX,@DATA
	MOV DS,AX
	
	PUSH [PUTERE]		; transmit parametrii prin striva
	PUSH [NUMAR]
	CALL Pow 		; Call the procedure 
	MOV [RES],AX		; Functia 'Pow' imi returneaza rezultatul in AX
	ADD SP,4		; Sterg de pe stiva parametrii

	PUSH [RES]		; Transmit parametru prin stiva
	CALL BinAsc		; Rezultatul se construieste in {StrAfis}
	POP AX			; Sterg parametrul de pe stiva

	MOV AH,09h
	MOV DX, OFFSET StrAfis	; Afisez string-ul ce contine rezultatul
	INT 21H

	MOV AH,4Ch 		; return to DOS
	INT 21h 		
	;
	;
Pow PROC			;prolog
	PUSH BP			;save bp
	MOV BP, SP		;put sp into bp
	
	MOV CX,[BP+6]
	DEC CX
	MOV AX,[BP+4]
AGAIN:	MUL word ptr [BP+4]
	LOOP AGAIN 
	
	POP BP			;epilog
	
	RET
Pow ENDP 
	;
	;
BinAsc PROC			;prolog
	PUSH BP			;save bp
	MOV BP, SP		;put sp into bp
	
	MOV CX,4
	MOV SI, OFFSET TEN_POWER
	MOV DI, (OFFSET StrAfis) + 11
NEXT:	MOV AX,[BP+4]
	MOV DX,0
	DIV word ptr [SI]
	MOV [BP+4],DX
	OR AL,30H
	MOV [DI],AL
	INC DI
	ADD SI,2
	LOOP NEXT
	OR DL,30H
	MOV [DI],DL
	
	POP BP			;epilog
	
	RET
BinAsc ENDP 
	;
END START