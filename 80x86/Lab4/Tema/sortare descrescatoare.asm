	DOSSEG
	.MODEL SMALL
	.STACK 32
	.DATA

NUMERE  DB  0Dh,0Ah,'Nr.(1)=$'
KBD	DB  9,0,0,0,0,0,0,0,0,0,0
STORE	DB 4 DUP (20h,20h,20h,20h,20h,20h,20h,20h)
INVERS	DB 0
	
	.CODE
START:	MOV AX,@DATA
	MOV DS,AX
	;
	CALL CITESTE
	CALL AFIS

AGGAIN:	CALL ORDON
	MOV AL,INVERS
	AND AL,AL
	JNZ AGGAIN
	
	CALL CRLF
	CALL AFIS
	
	MOV AH,4CH
	INT 21H
	
CITESTE:
	MOV CX,4
	MOV DI,(OFFSET STORE)+8
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
	ADD  DI,8
	POP CX
	LOOP AGAIN
	RET
	;
AFIS:	MOV CX,4
	MOV SI,OFFSET STORE
DISP:   CALL CRLF
	PUSH CX	
	MOV CX,8
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
	MOV DI,(OFFSET STORE)+8
	MOV CX,3
	
Next_O:	MOV AL,[DI]
	CMP [SI],AL
	JA  Go_comp
	JB  Go_chg
	MOV AL,[DI+1]
	CMP [SI+1],AL
	JA  Go_comp
	JB  Go_chg
	MOV AL,[DI+2]
	CMP [SI+2],AL
	JA  Go_comp
	JB  Go_chg
	MOV AL,[DI+3]
	CMP [SI+3],AL
	MOV AL,[DI+4]
	CMP [SI+4],AL
	JA  Go_comp
	JB  Go_chg
	MOV AL,[DI+5]
	CMP [SI+5],AL
	JA  Go_comp
	JB  Go_chg
	MOV AL,[DI+6]
	CMP [SI+6],AL
	JA  Go_comp
	JB  Go_chg
	MOV AL,[DI+7]
	CMP [SI+7],AL
	JA  Go_comp
	JB  Go_chg
	JAE Go_comp
Go_chg:	MOV AX,[SI]	; interschimba 2 valori pe 4 octeti
	XCHG AX,[DI]	; 2 cate 2 octeti
	MOV [SI],AX
	MOV AX,[SI+2]
	XCHG AX,[DI+2]
	MOV [SI+2],AX
	MOV AX,[SI+4]
	XCHG AX,[DI+4]
	MOV [SI+4],AX
	MOV AX,[SI+6]
	XCHG AX,[DI+6]
	MOV [SI+6],AX
	MOV INVERS,1
Go_comp:ADD SI,8		
	ADD DI,8	; trece la urmatorul numar si cu SI si cu DI
	LOOP Next_O	; face urmatorul pas, cu numerele noi
	RET
	;		
	END START
