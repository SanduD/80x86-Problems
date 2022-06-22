	DOSSEG
	.MODEL SMALL
	.STACK 32
	.DATA
MATINI	DB 11h,12h,13h,14h
		DB 21h,22h,23h,24h
		DB 31h,32h,33h,34h
		DB 41h,42h,43h,44h
				    
	.CODE
START:	MOV AX,@DATA
	MOV DS,AX
	MOV SI,OFFSET MATINI
	MOV CX,3		; (nr_linii-1) pentru a generaliza
LEXT:	MOV DX,CX
	ADD SI,4		; (nr_coloane) pentru a generaliza
	SUB SI,DX
	MOV BX, 3		; (nr_coloane) pentru a generaliza
LINT:		MOV AL,[SI]
		MOV AH,[SI+BX]
		MOV [SI],AH
		MOV [SI+BX], AL
		INC SI
		ADD BX, 3	; (nr_coloane) pentru a generaliza
		LOOP LINT
	MOV CX,DX
	LOOP LEXT
	MOV AH,4CH
	INT 21H
	END START
