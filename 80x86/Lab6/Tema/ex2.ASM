		DOSSEG
	
		.MODEL SMALL
		.STACK 32
		.DATA
SEC		DW 0
NUMAR		DB 0
TEN_POWER	DB 100,10	; puterile lui 10 in cod binar
NUMASC		DB 0Dh,'Viteza=   m/s$'
VITEZA		DB 10

               .CODE
TIMER:		DEC CS:[INDEX]			; subrutina de tratare a intreruperii ()
		JNZ Waitsec
		MOV CS:[INDEX],18		; contor de interuperi 
		MOV CS:[SECUNDA],1		; semnalizare secunda (mark la fiecare 18 intreruperi de ceas)
				
Waitsec:        JMP DWORD PTR CS: [OLD_IP]  ; salt indirect la vechea valoare din TVI
						; executam in continuare continutul rutinei initiale pentru INT 8
						; to prevent undesired effects (hangs/crashes)

OLD_IP 		DW ?	;salvez IP-ul subrutinei(vectorul) pentru a sti adresa de inceput a subrutinei initiale INT 8
OLD_CS		DW ?	;salvez CS-ul subrutinei(vectorul) pentru a sti segmentul subrutinei initiale INT 8
INDEX		DW 18	;pentru a seta variabila SECUNDA la fiecare 18 apeluri ale intreruperii INT 8 (~ la fiecare secunda)
SECUNDA		DB 0	;flag care marcheaza trecerea unei secunde
                ; 

START:		MOV AX,@DATA	; program principal
		MOV DS,AX	
		MOV AX, 0 	;initializam ES pentru inceputul memoriei(primul 1KB de memorie contine TVI )
						;fiecare vector din TVI are cate 4 octeti
						;(primi 2 octeti = IP-ul subrutinei si urmatorii 2 = CS-ul subrutinei)
						;1KB = 1024 Octeti = 4(fiecare vector) * 256(unsigned byte values)
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
		MOV AX, ES: [0020H]		; adresa de inceput a subrutinei INT 8 (8 * 4 = 32 = 0020H)
		MOV CS :[OLD_IP], AX		; salvare valoare IP
		MOV SI, OFFSET TIMER		; punem adresa de inceput a subrutinei noastre in TVI (la fiecare INT 8 se apeleaza acesta subrutina)
		MOV ES :[0020H], SI		; actualizare valoare IP
		MOV AX, ES: [0022H]
		MOV CS: [OLD_CS], AX		; salvare valoare CS
		MOV ES: [0022H], CS		; actualizare valoare CS (CS-ul codului meu)
		STI				; activare sistem de intreruperi
		;
AGAIN:		CALL CHECK
		MOV AL,CS:[SECUNDA]		; asteapta semnalizarea de 1 secunda
		AND AL,AL			; daca AL are valoare 1 atunci a trecut 1 sec iar JZ nu se mai executa
		JZ  AGAIN
		MOV CS:[SECUNDA],0		; resetam flagul SECUNDA la 0
		INC WORD PTR [SEC]		; incrementam secunda
		MOV AX,[SEC]
		;
		CMP AX,60
		JNE NEXTT
		MOV AH, 4CH
		INT 21H
		;
NEXTT:		CALL BINASC			;conversie BINASC
		MOV AH,9
		MOV DX,OFFSET NUMASC		;afisare secunda
		INT 21H
		JMP AGAIN
		MOV AH, 4CH
		INT 21H
		;
BINASC:		MOV CX,2		; din numere binare pe 16 biti
					; pot rezulta siruri ASCII cu 5 cifre
		MOV SI,OFFSET TEN_POWER	; pointer spre tabela puterilor lui 10
		MOV DI,(OFFSET NUMASC)+8
		MOV AL,[VITEZA]
		MOV [NUMAR],AL
NEXT:		
		MOV AL,[NUMAR]
		MOV AH,0		; pregateste deimpartitul pe 32 de biti
		DIV byte PTR [SI]	; obtine catul curent
		MOV [NUMAR],AH		; salveaza restul curent
		OR  AL,30H		; salveaza codul ASCII al cifrei curente
		MOV [DI],AL
		INC DI
		INC SI			; avanseaza pointerul spre urmatoarea putere a lui 10
		LOOP NEXT	
		OR  AH,30H		; salveaza codul ASCII al ultimei cifre (cifra unitatilor)
		MOV [DI],AH
		RET

CHECK:		MOV AH,06h
		MOV DL,255
		INT 21h
		JZ ENDD
		CMP AL,'a'
		JNE SUBB
		;MOV AH,[VITEZA]
		;CMP AH,240
		;JG NEXTTT
		;MOV [VITEZA],245
		;JMP ENDD
NEXTTT:		ADD [VITEZA],5
SUBB:		CMP AL,'d'
		JNE ENDD
		MOV AH,[VITEZA]
		CMP AH,3
		JGE NEXTTTT
		MOV [VITEZA],0
		JMP ENDD
NEXTTTT:	SUB [VITEZA],3				    
ENDD:		RET

		END START
                    
