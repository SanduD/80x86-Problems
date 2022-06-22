DOSSEG
.MODEL SMALL
.STACK 32
.DATA
CLOCK 		DB 0DH,' ', '00:00:00$'		; formatul de ceas
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

WAIT:		MOV AH,06h
		MOV DL,255
		CMP AL,0Dh
		JNE WAIT
		;
AGAIN:		    
		MOV AL,CS:[SECUNDA]	; copiez din programul atasat intreruperii variabila SECUNDA
		AND AL,AL		; verific daca AL(SECUNDA) = 0
		JZ  Check_Ex		; daca SECUNDA = 0, trec peste afisare/verificare format ceas 
					; si verific daca este apasata o tasta
		MOV CS:[SECUNDA],0	; daca SECUNDA = 1, o fac 0 si modific ceasul
		;
				
		MOV SI, (OFFSET CLOCK)+9; merg pe adresa unitatilor de minut ( secunde )
		MOV BX,3935H		; secundele merg pana la '59'
		CALL UPDATE		; adaug 1 si verific ce schimbari sunt de facut
		DEC AL			; verific daca AL=1	
		JNZ AGAIN		; daca este, nu trebuie sa mai fac UPDATE, reiau AGAIN
		SUB SI, 3		; trec pe urmatoarea pozitie (secunde->minute->ore)
		MOV BX,3935H		; minutele merg pana la '59'
		CALL UPDATE		; verific daca trebuie sa schimb si aici ceva
		DEC AL			
		JNZ AGAIN		
		SUB SI,3		
		MOV BX,3332H		; verificarea orei sa corespuna (maxim 23 de ore)
		CALL UPDATE
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
		INC BYTE PTR [SI]	
		CMP BYTE PTR [SI],39H	; verific daca am 9
		JBE GoOn		; daca valoarea este mai mica de 9, am terminat
		MOV BYTE PTR [SI],30H	; altfel pun 0 pe aceasta pozitie
		INC BYTE PTR [SI-1]	; si o cresc pe cea din stanga
GoOn:		RET
FOLLOW:		MOV [SI-1],3030h	; pun 00 pe pozitiile respective
		MOV AL, 1		; semnalizez ca am facut schimbarea
		RET
               	;
		;
                END START
                    
