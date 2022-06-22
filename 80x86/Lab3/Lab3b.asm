	DOSSEG
	.MODEL SMALL
	.STACK 32
	.DATA

	.CODE
START:	MOV AX,@DATA
	MOV DS,AX
	;
	MOV CX,32
	;
AGAIN:	MOV AH,1	; citeste caracter de la tastatura
	INT 21H
	;
    PUSH AX
	MOV AH,2	; afiseaza caracter pe ecran
	MOV DL,' '
	INT 21H
	POP AX
	;
	MOV AH,2	; afiseaza caracter pe ecran
	MOV DL,AL
	INT 21H
	;
	CALL CRLF
	;	
	LOOP AGAIN
	;
	MOV AH,4CH
	INT 21H
	;
CRLF:   MOV AH,2	; salt la inceput de rand
	MOV DL,0DH
	INT 21H
	MOV AH,2	; salt la rand nou
	MOV DL,0AH
	INT 21H
	RET
	;
	END START
