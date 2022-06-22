	DOSSEG
	.MODEL SMALL
	.STACK 32
	.DATA

NUMERE  DB  0Dh,0Ah,'Nr.(1)=$'
KBD	DB  3,0,0,0,0
STORE	DB 4 DUP (30h,30h)
INVERS	DB 0
	
	.CODE
START:	MOV AX,@DATA
	MOV DS,AX
	;
	CALL CITESTE
	
	CALL ORDON

	CALL CRLF
	CALL AFIS	; in afisare mai intai verific daca este divizibil cu 3
	
	MOV AH,4CH
	INT 21H
	
CITESTE:
	MOV CX,4
	MOV DI,(OFFSET STORE)+2 
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
	SUB  DI,CX		
NEXT:	MOV  AL,[SI]
	MOV  [DI],AL
	INC  SI			; memoreaza numar
	INC  DI
	LOOP NEXT
	POP  DI
	ADD  DI,2
	POP CX
	LOOP AGAIN
	RET
	;
AFIS:	MOV CX,4
	MOV SI,OFFSET STORE
DISP:   PUSH CX	
	
	CALL VERIF
	CMP AH,0
	JNE NONUM

	MOV AH,2
	MOV DL,' '
	INT 21h
	MOV CX,2
NUM:	MOV AH,2
	MOV DL,[SI]
	INT 21h			; afiseaza sirul de numere
	INC SI
	LOOP NUM
	POP CX
	LOOP DISP
	RET
NONUM:	ADD SI,2
	POP CX
	LOOP DISP
	RET
	;
VERIF:	MOV AL,[SI]
	MOV AH,0
	MOV BH,0
	MOV BL,[SI+1]
	AND AL,0Fh
	AND BL,0Fh
	ADD AL,BL
	MOV BH,3
	DIV byte ptr BH
	RET 
	;
CRLF:	MOV AH,2
	MOV DL,0Ah
	INT 21h
	MOV AH,2
	MOV DL,0Dh
	INT 21h
	RET
	;
ORDON:  MOV INVERS,0
	MOV SI,OFFSET STORE
	MOV DI,(OFFSET STORE)+2
	MOV CX,3
Next_O:	MOV AL,[DI]
	CMP AL,[SI]
	JA  Go_comp
	JB  Go_chg
	MOV AL,[DI+1]
	CMP AL,[SI+1]
	JAE Go_comp
Go_chg:	MOV AX,[SI]	; interschimba 2 valori pe 4 octeti
	XCHG AX,[DI]	; 2 cate 2 octeti
	MOV [SI],AX
	MOV INVERS,1
Go_comp:ADD SI,2		
	ADD DI,2	; trece la urmatorul numar si cu SI si cu DI
	LOOP Next_O	; face urmatorul pas, cu numerele noi
	MOV AL,INVERS
	AND AL,AL
	JNZ ORDON
	RET
	;		
	END START
