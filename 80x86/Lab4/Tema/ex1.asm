	DOSSEG
	.MODEL SMALL
	.STACK 32
	.DATA
KBD	DB  5,0,0,0,0,0,0

			; ~Afisarea buffer-ului KBD prin intermediul
			; ~ intreruperii AH 09/INT 21H.
			; ~Octetul 0Dh va fi suprascris cu 
			; ~ terminator de sir.
			
	.CODE
START:	MOV AX,@DATA
	MOV DS,AX

	MOV [KBD+1],0
	MOV AH,0Ah
	MOV DX,OFFSET KBD
	INT 21H			; citirea in buffer (KBD)

	CALL CRLF		; apel funtie pentru rand nou
		
	MOV CL,[KBD+1]
	MOV CH,0
	MOV SI,(OFFSET KBD)+2
VERF:	CMP byte ptr [SI],0Dh 	; caut 0Dh
	JE CHNG
	INC SI
	LOOP VERF

CHNG:	MOV byte ptr[SI],'$'	; schimb 0Dh cu terminator de sir '$'
	
AFIS:	MOV AH,09h		
	MOV DX,(OFFSET KBD)+2
	INT 21h			; afisez string-ul

	MOV AH,4CH
	INT 21H

CRLF:	MOV AH,2		
	MOV DL,0Ah
	INT 21h
	MOV AH,2
	MOV DL,0Dh
	INT 21h
	RET

	END START
