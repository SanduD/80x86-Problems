	DOSSEG
	.MODEL SMALL
	.STACK 32
	.DATA
SIR	 DD 16 DUP(20202020h)
	.CODE
START:	MOV AX,@DATA
	MOV DS,AX
	;
	MOV CX,16
	MOV BX,OFFSET SIR
NEW_N:	PUSH CX
	MOV CX,4
	MOV SI,0
NEXT_D:	MOV AH,1	
	INT 21H
	CMP AL,0Dh
	JZ  NEXT_N
	MOV [BX+SI],AL
	INC SI	
	LOOP NEXT_D
	CALL CRLF
NEXT_N: ADD  BX,4
	POP  CX
	LOOP NEW_N
	CALL CRLF
	;
	MOV CX,4*16
	MOV SI,OFFSET SIR
	;
AGAIN:	MOV AH,2	
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
