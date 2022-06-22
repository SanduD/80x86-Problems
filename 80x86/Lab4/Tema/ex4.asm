	DOSSEG
	.MODEL SMALL
	.STACK 32
	.DATA
NUMERE  DB  0Dh,0Ah,'Nr.(1)=$'
KBD	DB  9,0,0,0,0,0,0,0,0,0,0
STORE	DB 6 DUP (20h,20h,20h,20h,20h,20h,20h,20h)

	.CODE
START:	MOV AX,@DATA
	MOV DS,AX
	MOV CX,6
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
	;
	MOV AH,[SI]		; mut in AH valoarea de la adresa SI
	CALL VERIF		; functie verificare litera
	CMP BL,1		
	JE NEXT			; in functie de BL schimb sau nu val
	MOV byte ptr [SI],'9'
	;
NEXT:	MOV  AL,[SI]
	MOV  [DI],AL
	INC  SI			; memoreaza numar
	INC  DI
	;
	MOV AH,[SI]
	CALL VERIF
	CMP BL,1
	JE NEXTT
	MOV byte ptr [SI],'0'
	;
NEXTT:	LOOP NEXT
	POP  DI
	ADD  DI,8	
	POP CX
	LOOP AGAIN
	;
	MOV CX,6
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
VERIF:	MOV BL,1
	CMP AH,'A'
	JL ENDVER
	CMP AH,'z'
	JG ENDVER
	CMP AH,'Z'	; functie care verifica daca AH 
	JLE STRUE	; este litera mica sau mai mare
	CMP AH,'a'	; seteaza BL (0-verifica | 1-NU verifica)
	JGE STRUE
	JMP ENDVER
STRUE:	MOV BL,0
ENDVER:	RET
	;
	END START

	; ~imi citeste de 8 ori numere de maxim 4 cifre
	; ~stocheaza numerele in cele 8 zone de memorie de la e:STORE
	; ~afiseaza cele 8 numere, pe cate un rand fiecare (CRLF)
