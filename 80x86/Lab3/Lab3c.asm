	DOSSEG
	.MODEL SMALL
	.STACK 32
	.DATA
SIR	DB 'Hello world!'
	.CODE
START:	MOV AX,@DATA
	MOV DS,AX
	;
	MOV CX,12
	MOV SI,OFFSET SIR
	CALL CRLF
	;
AGAIN:	MOV AH,2	; afiseaza caracter pe ecran
	MOV DL,[SI]
	INT 21H
	INC SI
	;	
	LOOP AGAIN
	CALL CRLF
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
