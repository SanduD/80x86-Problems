DOSSEG
.MODEL SMALL
.STACK 32
.DATA
MSGINIT		DB 0DH,0AH,'Introduceti timpul (00:00:00): $'
CLOCK 		DB 0DH,' ', '00:00:00$'		; formatul de ceas
KBD		DB 9,0,0,0,0,0,0,0,0,0,0
DELLINE		DB 0DH,'                                                            ', 0DH,'$'
ENDMSG		DB 0DH,'Bomba a explodat!$'
.CODE

TIMER:	    	DEC CS:[INDEX]		; la fiecare semnal scade 1 din index 
		JNZ Waitsec		; daca intex-ul nu a ajuns la 0, mai asteapta un semnal
		MOV CS:[INDEX],18	; 18.2ms pentru o secunda (un semnal la 55ms) [index reia numaratoarea]
		MOV CS:[SECUNDA],1	; seteaza secunda (semnalizeaza ca a trecut o secunda)
				
Waitsec:     	JMP DWORD PTR CS: [OLD_IP]		; se intoarce la secventa de cod existenta anterior in intrerupere
                    ;
OLD_IP 		    DW ?
OLD_CS 		    DW ?
INDEX 		    DW 18
SECUNDA 	    DB 0

START:          
		MOV AX,@DATA
		MOV DS,AX
		;
		MOV AX, 0
		MOV ES, AX
		CLI			; dezactivez sistemul de intreruperi
		;
		MOV AX, ES: [0020H]	; construiesc Extra-Segment
		MOV CS :[OLD_IP], AX	; memorez IP vechi
		MOV SI, OFFSET TIMER	
		MOV ES :[0020H], SI	; introduc secventa de cod scrisa la eticheta TIMER in ES
		;
		MOV AX, ES: [0022H]
		MOV CS: [OLD_CS], AX	; retin si vechiul segment de cod
		MOV ES: [0022H], CS
		STI			; activez sistemul de intreruperi
		;
		CALL READTM
WAITSEM:	MOV AH,06H		; asteapta apasarea tastei 'Enter' pentru pornire
		MOV DL,255
		INT 21H
		CMP AL,0DH
		JNE WAITSEM
		;
AGAIN:		    
		MOV AL,CS:[SECUNDA]	; copiez din programul atasat intreruperii variabila SECUNDA
		AND AL,AL		; verific daca AL(SECUNDA) = 0
		JZ  Check_Ex		; daca SECUNDA = 0, trec peste afisare/verificare format ceas 
					; si verific daca este apasata o tasta
		MOV CS:[SECUNDA],0	; daca SECUNDA = 1, o fac 0 si modific ceasul
		;
		MOV AH, 9
		MOV DX, OFFSET CLOCK	; afisez CLOCK (formatul de ceas)
		INT 21H			
		MOV SI, (OFFSET CLOCK)+9; merg pe adresa unitatilor de minut ( secunde )
		MOV BX,3030H		; secundele merg pana la '59'
		CALL UPDATE		; adaug 1 si verific ce schimbari sunt de facut
		DEC AL			; verific daca AL=1	
		JNZ AGAIN		; daca este, nu trebuie sa mai fac UPDATE, reiau AGAIN
		SUB SI, 3		; trec pe urmatoarea pozitie (secunde->minute->ore)
		MOV BX,3030H		; minutele merg pana la '59'
		CALL UPDATE		; verific daca trebuie sa schimb si aici ceva
		DEC AL			
		JNZ AGAIN		
		SUB SI,3		
		MOV BX,3030H		; verificarea orei sa corespuna (maxim 23 de ore)
		CALL UPDATE
		;
		CALL VERIF
	       	;
Check_Ex:	    
		MOV AH,0BH		; verific daca s-a apasat o tasta
		INT 21H			; daca nu s-a apasat, continui executia
		INC AL
		JNZ AGAIN
		;
		CLI
		MOV AX,0
		MOV ES,AX
		MOV AX,CS:[OLD_IP]	; modific schimbarile la sistemul de intreruperi
		MOV ES:[0020H],AX	; sterg codul introdus anterior
		MOV AX,CS:[OLD_CS]
		MOV ES: [0022H],AX
		STI
		;
		MOV AH, 4CH
		INT 21H			
		;
UPDATE: 	MOV AL, 0
		MOV DX, [SI-1] 		; ma mut pe cifra unitatilor
		CMP DX, BX		; verific cu BX (setat inainte de apel)
		JE  FOLLOW		; daca a ajuns la valoarea maxima (BX) aceasta unitate 
		DEC BYTE PTR [SI]	
		CMP BYTE PTR [SI],30H	; verific daca am 9
		JAE GoOn		; daca valoarea este mai mica de 9, am terminat
		MOV BYTE PTR [SI],39H	; altfel pun 0 pe aceasta pozitie
		DEC BYTE PTR [SI-1]	; si o cresc pe cea din stanga
GoOn:		RET
FOLLOW:		MOV [SI-1],3935h	; pun 00 pe pozitiile respective
		MOV AL, 1		; semnalizez ca am facut schimbarea
		RET
               	;
READTM:		MOV AH,09H
		MOV DX,(OFFSET MSGINIT)
		INT 21H
		MOV [KBD+1],0
		MOV AH,0AH
		MOV DX,(OFFSET KBD)
		INT 21H
		MOV AL,[KBD+1]
		CMP AL,8
		JNE READTM
		MOV AL,[KBD+2]		; initializez orele
		MOV [CLOCK+2],AL
		MOV AL,[KBD+3]	
		MOV [CLOCK+3],AL
	
		MOV AL,[KBD+5]		; initializez minutele
		MOV [CLOCK+5],AL
		MOV AL,[KBD+6]
		MOV [CLOCK+6],AL
	
		MOV AL,[KBD+8]		; initializez secundele
		MOV [CLOCK+8],AL
		MOV AL,[KBD+9]
		MOV [CLOCK+9],AL

		MOV AH,09H
		MOV DX,(OFFSET DELLINE)
		INT 21H
		RET
		;
VERIF:		MOV AL,[CLOCK+2]
		CMP AL,35h
		JNE ENDDD
		MOV AL,[CLOCK+3]
		CMP AL,39h
		JNE ENDDD

		MOV AL,[CLOCK+5]
		CMP AL,35h
		JNE ENDDD
		MOV AL,[CLOCK+6]
		CMP AL,39h
		JNE ENDDD

		MOV AL,[CLOCK+8]
		CMP AL,35h
		JNE ENDDD
		MOV AL,[CLOCK+9]
		CMP AL,39h
		JNE ENDDD
		
		MOV AH,09h
		MOV DX,(OFFSET DELLINE)
		INT 21H
		MOV AH,09h
		MOV DX,(OFFSET ENDMSG)
		INT 21H
		MOV AH, 4CH
		INT 21H	
ENDDD:		RET
		;
                END START
                    
