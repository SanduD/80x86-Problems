	DOSSEG
	.MODEL SMALL
	.STACK 32
	.DATA
SIR	DB 16 DUP(0)
MATTR   DB 16 DUP(0)
	.CODE
START:	MOV AX,@DATA
	MOV DS,AX
	;
	MOV CX,16
	MOV SI,OFFSET SIR
	CALL CRLF
NEXT:	MOV AH,1	
	INT 21H
	MOV [SI],AL
	INC SI
	;	
	LOOP NEXT
	CALL CRLF
	;
	MOV CX,4
	MOV SI,OFFSET SIR
	CALL CRLF
	;
ROW:	PUSH CX
	MOV CX,4
COL:	MOV AH,2	
	MOV DL,[SI]
	INT 21H
	INC SI
        MOV AH,2 	
	MOV DL,' '
	INT 21H	
	LOOP COL
	CALL CRLF
	POP CX
	LOOP ROW
	;
	CALL CRLF
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
	END START