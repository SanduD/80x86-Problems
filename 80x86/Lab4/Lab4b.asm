	DOSSEG
	.MODEL SMALL
	.STACK 32
	.DATA
NUMERE  DB  0Dh,0Ah,'Nr.(1)=$'
KBD	DB  5,0,0,0,0,0,0

	.CODE
START:	MOV AX,@DATA
	MOV DS,AX
	;
	MOV CX,8
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
	MOV SI,(offset KBD)+2
	MOV AH,2
	MOV DL,0Dh		; ~merge la inceput de rand 
	INT 21h
	MOV AH,2		
	MOV DL,0Ah		; ~merge pe urmatorul rand
	INT 21h
NEXT:	MOV AH,2
	MOV DL,[SI]
	INT 21h			; afiseaza numarul introdus
	INC SI
	LOOP NEXT
	;	
	POP CX
	LOOP AGAIN
	;
	MOV AH,4CH
	INT 21H
	END START
	
	; ~imi afiseaza 'NUMERE' apoi citeste un numar de maxim 4 cifre
	; in KBD, apoi imi afiseaza numarul (cele 4 cifre)
	; ~face asta de 8 ori (CX initial, retinut pe stiva) 
