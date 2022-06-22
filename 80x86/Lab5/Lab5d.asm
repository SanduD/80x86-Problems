             	DOSSEG
             	.MODEL SMALL
             	.STACK 16
             	.DATA
NUMAR           DW 0			; numar in cod binar
TEN_POWER    	DW 10000,1000,100,10	; puterile lui 10 in cod binar
KBD	     	DB 5,0,0,0,0,0,0
SUMA		DW 0
NUMASC	     	DB 0Dh,0Ah,'Suma =     $'
SIR		DB 0Dh,0Ah,'N(1)=$'
             	.CODE
START:       	MOV AX, @DATA
             	MOV DS, AX                       
		; 			program principal			
		MOV CX,4
CICLU:		PUSH CX
		CALL ASK
		CALL READ
		CALL ASCBIN
		POP CX
		LOOP CICLU
		;
		CALL BINASC
		CALL AFIS
		MOV AH,4CH
                INT 21H
		;
ASK:		MOV AH,9
		MOV DX,OFFSET SIR
		INT 21H
		INC BYTE PTR [SIR+4]
		MOV [NUMAR],0
		RET

READ:		MOV AH,0Ah		; citire numar de la tastatura
		MOV DX,OFFSET KBD
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
		MOV BX,10
		MOV SI,(OFFSET KBD)+2
AGAIN:		MOV AX,[NUMAR]
		MUL BX			; inmulteste suma partiala cu 10
		MOV DL,[SI]
		MOV DH,0
		AND DL,0FH		; conversie ASCII binar pentru cifra curenta
		ADD AX,DX		; aduna cifra curenta
		MOV [NUMAR],AX
		INC SI
		LOOP AGAIN
		ADD [SUMA],AX
		RET
		;
BINASC:		MOV CX,4		; din numere binare pe 16 biti
					; pot rezulta siruri ASCII cu 5 cifre
		MOV SI,OFFSET TEN_POWER	; pointer spre tabela puterilor lui 10
		MOV DI,(OFFSET NUMASC)+8
NEXT:		MOV AX,[SUMA]
		MOV DX,0		; pregateste deimpartitul pe 32 de biti
		DIV WORD PTR [SI]	; obtine catul curent
		MOV [SUMA],DX		; salveaza restul curent
		OR  AL,30H		; salveaza codul ASCII al cifrei curente
		MOV [DI],AL
		INC DI
		ADD SI,2		; avanseaza pointerul spre urmatoarea putere a lui 10
		LOOP NEXT	
		OR  DL,30H		; salveaza codul ASCII al ultimei cifre (cifra unitatilor)
		MOV [DI],DL
		RET
		;
                END START
