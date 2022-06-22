             	DOSSEG
             	.MODEL SMALL
             	.STACK 16
             	.DATA
TEN_POWER    	DW 10000,1000,100,10	; puterile lui 10 in cod binar
KBD	     	DB 5,0,0,0,0,0,0
TOTAL		DW 0
SEMN		DB 0
STORE 		DW 4 DUP (0)
NUMASC	     	DB 0Dh,0Ah,'Suma =      $'
SIR_In		DB 0Dh,0Ah,'N(1)=$'
             	.CODE
START:       	MOV AX, @DATA
             	MOV DS, AX                       
		; 			program principal			
		MOV CX,4
		MOV DI,OFFSET STORE
CICLU:		
		CALL ASK
		MOV AH,1
		INT 21h
		CMP AL,'-'
		JNZ PLUS
		MOV SEMN,1
		JMP NEXTT
PLUS:		MOV KBD,4
		AND AL,0Fh		; transforma AL in binar
		CBW			; sign extend pentru AL
		MOV word ptr [DI],AX

NEXTT:		PUSH CX
		CALL READ
		CALL ASCBIN
		POP CX
		LOOP CICLU
		CALL CRLF
		;
		MOV CX,4
		MOV DI,OFFSET STORE
CICLU2:		PUSH CX
		CALL BINASC2
		;CALL CRLF
		POP CX
		LOOP CICLU2
		
		CALL SUMA1
		MOV DI,OFFSET TOTAL
		CALL BINASC
		
		MOV AH,4CH
                INT 21H
		;
ASK:		MOV AH,9
		MOV DX,OFFSET SIR_In
		INT 21H
		INC byte ptr [SIR_In+4]
		MOV byte ptr [DI],0
		RET

READ:		MOV AH,0Ah		; citire numar de la tastatura
		MOV DX,OFFSET KBD
		INT 21h
		RET
		;
CRLF:		MOV AH,2
		MOV DL,0Dh
		INT 21h
		MOV AH,2
		MOV DL,0Ah
		INT 21h
		RET
		;
AFIS:		MOV AH,09h
		MOV DX,OFFSET NUMASC
		INT 21H
	        RET
		;
ASCBIN:         MOV CH,0		; CX <- contorul de cifre
		MOV CL,[KBD+1]
		AND CX,CX
		JZ EXITAB
		MOV BX,10
		MOV SI,(OFFSET KBD)+2
AGAIN:		MOV AX,[DI]
		MUL BX			; inmulteste suma partiala cu 10
		MOV DL,[SI]
		MOV DH,0
		AND DL,0FH		; conversie ASCII binar pentru cifra curenta
		ADD AX,DX		; aduna cifra curenta
		MOV [DI],AX
		INC SI
		LOOP AGAIN
		MOV AL,SEMN
		AND AL,AL
		JZ EXITAB
		NEG word ptr [DI]
		MOV SEMN,0
EXITAB:		ADD DI,2
		MOV KBD,5
		RET
		;
BINASC2:	MOV CX,4		; din numere binare pe 16 biti
					; pot rezulta siruri ASCII cu 5 cifre
		MOV SI,OFFSET TEN_POWER	; pointer spre tabela puterilor lui 10
		MOV AX,[DI]
		PUSH AX
		AND AX,AX
		JNS NEXTTT
		NEG WORD PTR [DI]
		MOV AH,2
		MOV DL,'-'
		;INT 21h
NEXTTT:		PUSH CX
		MOV AX,[DI]
		MOV DX,0		; pregateste deimpartitul pe 32 de biti
		DIV WORD PTR [SI]	; obtine catul curent
		MOV [DI],DX		; salveaza restul curent
		OR  AL,30H		; salveaza codul ASCII al cifrei curente
		MOV DL,AL
		MOV AH,2
		;INT 21h
		ADD SI,2		; avanseaza pointerul spre urmatoarea putere a lui 10
		POP CX
		LOOP NEXTTT
		MOV DL,[DI]	
		OR  DL,30H		; salveaza codul ASCII al ultimei cifre (cifra unitatilor)
		MOV AH,2
		;INT 21h
		
		POP [DI]
		ADD DI,2
		RET
		;
BINASC:		MOV CX,4		; din numere binare pe 16 biti
					; pot rezulta siruri ASCII cu 5 cifre
		MOV SI,OFFSET TEN_POWER	; pointer spre tabela puterilor lui 10
		MOV AX,[DI]
		PUSH AX
		AND AX,AX
		JNS NEXT
		NEG WORD PTR [DI]
		MOV AH,2
		MOV DL,'-'
		INT 21h
NEXT:		PUSH CX
		MOV AX,[DI]
		MOV DX,0		; pregateste deimpartitul pe 32 de biti
		DIV WORD PTR [SI]	; obtine catul curent
		MOV [DI],DX		; salveaza restul curent
		OR  AL,30H		; salveaza codul ASCII al cifrei curente
		MOV DL,AL
		MOV AH,2
		INT 21h
		ADD SI,2		; avanseaza pointerul spre urmatoarea putere a lui 10
		POP CX
		LOOP NEXT
		MOV DL,[DI]	
		OR  DL,30H		; salveaza codul ASCII al ultimei cifre (cifra unitatilor)
		MOV AH,2
		INT 21h
		
		POP [DI]
		ADD DI,2
		RET
		;
SUMA1:		MOV CX,4
		MOV SI,OFFSET STORE
SUMA2:		MOV AX,[SI]
		ADD TOTAL,AX
		ADD SI,2
		LOOP SUMA2
		RET
		;
                END START
