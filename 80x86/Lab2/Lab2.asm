	DOSSEG
	.MODEL SMALL
	.STACK 32
	.DATA
MATINI	DB 11h,12h,13h,14h 	; matricea initiala
		DB 21h,22h,23h,24h
		DB 31h,32h,33h,34h
		DB 41h,42h,43h,44h
MATTR	DB 16 DUP(0)		; zona de memorie pentru matricea transpusa				    
	.CODE
START:	MOV AX,@DATA
		MOV DS,AX
		MOV SI,OFFSET MATINI	; initializare pointer MATINI
		MOV DI,OFFSET MATTR	; initializare pointer MATTR
		MOV CX,4		; initializare contor de ciclu linii
LEXT:	MOV DX,CX		; salvare contor ciclu exterior
		MOV CX,4	; initializare contor de ciclu coloane (interior)
LINT:	MOV AL,[SI]
		MOV [DI],AL
		INC SI
		ADD DI,4
		LOOP LINT	; terminare ciclu interior
		SUB DI,0Fh
		MOV CX,DX		; reface contorul de ciclu exterior
		LOOP LEXT		; terminare ciclu exterior
		MOV AH,4CH
		INT 21H			; EXIT (revenire in SO)
	END START
