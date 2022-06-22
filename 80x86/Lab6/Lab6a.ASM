	DOSSEG
	.MODEL SMALL
	.STACK 32
	.DATA
CLOCK DB 0AH, 0DH, '00:00:00$' ; '$' terminator de sir
	.CODE
START:	
	MOV AX, @DATA
	MOV DS,AX
	;	
AGAIN:		     
	MOV AH, 1
	INT 21H
	CMP AL,0DH
	JZ  GATA
	;
	MOV AH, 9		  ; functia de afisare sir de caractere
	MOV DX, OFFSET CLOCK ; DX <- pointer spre sir
	INT 21H						
	MOV SI, (OFFSET CLOCK)+9
	mov  BX,3935H		; compara in functia UPDATE valoarea
	CALL UPDATE		; de la CLOCK+9 (minute) cu BX
	DEC AL
	JNZ AGAIN
	SUB SI, 3
	mov  BX,3935H
	CALL UPDATE
	DEC AL
	JNZ AGAIN
	SUB SI,3
	mov  BX,3332H
	CALL UPDATE
	DEC AL
	JNZ AGAIN
	;					
GATA:	
    	MOV AH,4CH
	INT 21H
	;
UPDATE: 	     
	MOV AL, 0
	MOV DX, [SI-1]
	CMP DX, BX
	JE  FOLLOW
	INC BYTE PTR [SI]
	CMP BYTE PTR [SI],39H
	JBE GoOn
	MOV BYTE PTR [SI],30H
	INC BYTE PTR [SI-1]
GoOn:
    RET
FOLLOW:
    MOV [SI-1],3030h
	MOV AL, 1
	RET
	;
	END START