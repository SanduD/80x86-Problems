DOSSEG
.MODEL SMALL
.STACK 32
.DATA
SEC		    DW 0
NUMAR		    DW 0
TEN_POWER	    DW 10000,1000,100,10	; puterile lui 10 in cod binar
NUMASC	     	    DB 0Dh,'Timp=     $'
                    
.CODE

TIMER:	    	
				DEC CS:[INDEX]			; subrutina de tratare a intreruperii
				JNZ Waitsec
				MOV CS:[INDEX],18		; contor de interuperi 
								; (cereri cu frecventa de 18Hz)
				MOV CS:[SECUNDA],1		; semnalizare secunda
Waitsec:        JMP DWORD PTR CS: [OLD_IP]  ; salt indirect la vechea valoare din TVI
OLD_IP 		    DW ?
OLD_CS 		    DW ?
INDEX 		    DW 18
SECUNDA 	    DB 0
                    ; 
START:             
				MOV AX,@DATA		; program principal
				MOV DS,AX
				MOV AX, 0
				MOV ES, AX
		    ;
				MOV AH,2			; salt la rand nou
				MOV DL,0Dh
				INT 21h
				MOV AH,2
				MOV DL,0Ah
				INT 21h
		    ;
				CLI				; dezactivare sistem de intreruperi
				MOV AX, ES: [0020H]		
				MOV CS :[OLD_IP], AX	; salvare valoare IP
				MOV SI, OFFSET TIMER
				MOV ES :[0020H], SI		; actualizare valoare IP
				MOV AX, ES: [0022H]
				MOV CS: [OLD_CS], AX	; salvare valoare CS
				MOV ES: [0022H], CS		; actualizare valoare CS
				STI				; activare sistem de intreruperi
				;
AGAIN:		    
				MOV AL,CS:[SECUNDA]		; asteapta semnalizarea de 1 secunda
				AND AL,AL
				JZ  Check_Ex
				MOV CS:[SECUNDA],0
				INC WORD PTR [SEC]
				MOV AX,[SEC]
				MOV [NUMAR],AX
				CALL BINASC
				MOV AH,9
				MOV DX,OFFSET NUMASC
				INT 21H
				JMP AGAIN
		    ;
Check_Ex:	    
				MOV AH,0BH			; testeaza existenta unei taste apasate
				INT 21H				; si daca se apasa, se opreste executia programului
				INC AL
				JNZ AGAIN
		    ;
				CLI
				MOV AX,0			; reface continutul TVI
				MOV ES,AX
				MOV AX,CS:[OLD_IP]
				MOV ES:[0020H],AX
				MOV AX,CS:[OLD_CS]
				MOV ES:[0022H],AX
				STI
				MOV AH, 4CH
				INT 21H
		    ;
BINASC:		    
				MOV CX,4		        ; din numere binare pe 16 biti
					        ; pot rezulta siruri ASCII cu 5 cifre
				MOV SI,OFFSET TEN_POWER	; pointer spre tabela puterilor lui 10
				MOV DI,(OFFSET NUMASC)+6
NEXT:		    
				MOV AX,[NUMAR]
				MOV DX,0		; pregateste deimpartitul pe 32 de biti
				DIV WORD PTR [SI]	; obtine catul curent
				MOV [NUMAR],DX		; salveaza restul curent
				OR  AL,30H		; salveaza codul ASCII al cifrei curente
				MOV [DI],AL
				INC DI
				ADD SI,2		; avanseaza pointerul spre urmatoarea putere a lui 10
				LOOP NEXT	
				OR  DL,30H		; salveaza codul ASCII al ultimei cifre (cifra unitatilor)
				MOV [DI],DL
				RET		    

                END START
                    
