	DOSSEG
	.MODEL SMALL
	.STACK 32
	.DATA
NUMERE  DB  0Dh,0Ah,'Nr.(1)=$'
KBD	DB  5,0,0,0,0,0,0
STORE	DB 8 DUP (20h,20h,20h,20h)

	.CODE
START:	MOV AX,@DATA
	MOV DS,AX
	MOV CX,8
	MOV DI,OFFSET STORE
AGAIN:	PUSH CX
	MOV DX,OFFSET NUMERE
	MOV AH,9
	INT 21H			; afiseaza sir de interogare
	INC [NUMERE+6]
	;
	MOV [KBD+1],0
	MOV AH,0Ah
	MOV DX,OFFSET KBD
	INT 21H		        ; citeste numar cu 1 pana la 4 cifre
	;
	MOV CL,[KBD+1]
	MOV CH,0
	MOV SI,(OFFSET KBD)+2
	PUSH DI
NEXT:	MOV  AL,[SI]
	MOV  [DI],AL
	INC  SI			; memoreaza numar
	INC  DI
	LOOP NEXT
	POP  DI
	ADD  DI,4	
	POP CX
	LOOP AGAIN
	;
	MOV CX,8
	MOV SI,OFFSET STORE
DISP:   CALL CRLF
	PUSH CX	
	MOV CX,4
NUM:	MOV AH,2
	MOV DL,[SI]
	INT 21h			; afiseaza sirul de numere
	INC SI
	LOOP NUM
	POP CX
	LOOP DISP	
	;
	MOV AH,4CH
	INT 21H
	;
CRLF:	MOV AH,2
	MOV DL,0Ah
	INT 21h
	MOV AH,2
	MOV DL,0Dh
	INT 21h
	RET
	;
	END START

	; ~imi citeste de 8 ori numere de maxim 4 cifre
	; ~stocheaza numerele in cele 8 zone de memorie de la e:STORE
	; ~afiseaza cele 8 numere, pe cate un rand fiecare (CRLF)
