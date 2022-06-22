	DOSSEG
	.MODEL SMALL
	.STACK 32
	.DATA

NUMERE  DB  0Dh,0Ah,'Nr.(1)=$'
KBD	DB  5,0,0,0,0,0,0
STORE	DB 4 DUP (30h,30h,30h,30h)
INVERS	DB 0
	
	.CODE
START:	MOV AX,@DATA
	MOV DS,AX
	;
	CALL CITESTE
	CALL AFIS
	CALL ORDON
	CALL CRLF
	CALL AFIS
	
	MOV AH,4CH
	INT 21H
	
CITESTE:
	MOV CX,4
	MOV DI,(OFFSET STORE)+4 
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
	ADD  DI,4
	POP CX
	LOOP AGAIN
	RET
	;
AFIS:	MOV CX,4
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
	MOV DI,(OFFSET STORE)+4
	MOV CX,3			; n-1 (n = numarul de numere)
Next_O:	MOV AL,[DI]
	CMP AL,[SI]
	JA  Go_comp
	JB  Go_chg
	MOV AL,[DI+1]
	CMP AL,[SI+1]
	JA  Go_comp
	JB  Go_chg
	MOV AL,[DI+2]
	CMP AL,[SI+2]
	JA  Go_comp
	JB  Go_chg
	MOV AL,[DI+3]
	CMP AL,[SI+3]
	JAE Go_comp
Go_chg:	MOV AX,[SI]	; interschimba 2 valori pe 4 octeti
	XCHG AX,[DI]	; 2 cate 2 octeti
	MOV [SI],AX
	MOV AX,[SI+2]
	XCHG AX,[DI+2]
	MOV [SI+2],AX
	MOV INVERS,1
Go_comp:ADD SI,4		
	ADD DI,4	; trece la urmatorul numar si cu SI si cu DI
	LOOP Next_O	; face urmatorul pas, cu numerele noi
	MOV AL,INVERS
	AND AL,AL
	JNZ ORDON
	RET
	;		
	END START
