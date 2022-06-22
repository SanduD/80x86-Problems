                        DOSSEG
                        .MODEL SMALL
                        .STACK 16
                        .DATA
NUMAR			DW 17458		; numar in cod binar
TEN_POWER		DW 10000,1000,100,10	; puterile lui 10 in cod binar

                        .CODE

START:                  MOV AX, @DATA
                        MOV DS, AX
			;                        
			; program principal			
			;
			MOV CX,4		; din numere binare pe 16 biti
						; pot rezulta siruri ASCII cu 5 cifre
			MOV SI,OFFSET TEN_POWER	; pointer spre tabela puterilor lui 10
NEXT:			MOV AX,[NUMAR]
			MOV DX,0		; pregateste deimpartitul pe 32 de biti
			DIV WORD PTR [SI]	; obtine catul curent
			MOV [NUMAR],DX		; salveaza restul curent
			MOV AH,2
			MOV DL,AL
			OR  DL,30H		; afiseaza codul ASCII al cifrei curente
			INT 21H
			ADD SI,2		; avanseaza pointerul spre urmatoarea putere a lui 10
			LOOP NEXT
			MOV DX,[NUMAR]		
			MOV AH,2
			OR  DL,30H		; afiseaza codul ASCII al ultimei cifre (cifra unitatilor)
			INT 21H
			;
                        MOV AH, 4CH
                        INT 21H
			;
			; subrutine
			;

			;
                        END START
