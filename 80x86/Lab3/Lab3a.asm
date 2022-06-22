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
	MOV AH,2	; afiseaza caracter pe ecran
	MOV DL,AL
	INT 21H
	;	
	LOOP AGAIN
	;
	MOV AH,4CH
	INT 21H
	END START
