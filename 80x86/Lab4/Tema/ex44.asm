	DOSSEG
	.MODEL SMALL
	.STACK 32
	.DATA
NUMERE  DB  0Dh,0Ah,'Nr.(1)=$'
KBD	DB  9,0,0,0,0,0,0,0,0,0,0
STORE	DB 8 DUP (20h,20h,20h,20h,20h,20h,20h,20h)

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
	INT 21H		        ; citeste un string cu 1-8 caractere
	;
	MOV CL,[KBD+1]
	MOV CH,0
	MOV SI,(OFFSET KBD)+2
	PUSH DI
NEXT:	MOV  AL,[SI]
	MOV  [DI],AL
	INC  SI			; memoreaza string
	INC  DI
	LOOP NEXT
	POP  DI
	ADD  DI,8	
	POP CX
	LOOP AGAIN
	;

	MOV SI,OFFSET STORE	; modificare dupa regula
	MOV CX,6
	PUSH CX
STRR:	MOV CX,8

LITT:	CMP byte ptr [SI],'z'
	JGE VERF
	CMP byte ptr [SI],'A'
	JL VERF	
	CMP byte ptr [SI],'a'
	JGE NEXTT
	CMP byte ptr [SI],'Z'
	JG VERF 
NEXTT:	MOV byte ptr [SI],'9'
	CMP CX,8
	JE VERF
NEXTTT: MOV byte ptr [SI],'0'
	
VERF:	INC SI
	LOOP LITT
	
FINN:	POP CX
	LOOP STRR		; modificare dupa regula

	;
	CALL CRLF
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
	END START