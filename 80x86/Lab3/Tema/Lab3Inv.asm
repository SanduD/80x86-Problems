	DOSSEG
	.MODEL SMALL
	.STACK 32
	.DATA
Msg	DB 'Toader Radu$' 
	
	; Merg pana la space, trec de space apoi afisez litera cu litera (si le fac mari) pana cand ajung la '&', apoi o iau de la inceput si afisez pana la space.

	.CODE
START:	MOV AX,@DATA
	MOV DS,AX
	
	MOV BX, 0
	MOV SI, OFFSET Msg

PARC:	MOV AL,[SI+BX]		; parcurg pana ajung la nume		
	INC BX
	CMP AL,' '
	JNE PARC 

AFISP:	MOV AH,2		; afisez prenumele cu litere mari
	MOV DL,[SI+BX]
	INC BX
	CMP DL,'$'		; cand ajung la '$' ma opresc
	JE NEXT
	CMP DL,'a'
	JL JJMP
	SUB DL, 20h
JJMP:	INT 21h
	JMP AFISP

NEXT:	MOV AH,2		; afisez un spatiu
	MOV DL,' '
	INT 21h
	
	MOV BX,0		; afisez numele, ma opresc la ' '
	MOV DL,[SI+BX]
AFISN:	MOV AH,2		
	INT 21h
	INC BX
	MOV DL,[SI+BX]
	CMP DL,' '
	JNE AFISN

	MOV AH,4CH
	INT 21H
	END START
