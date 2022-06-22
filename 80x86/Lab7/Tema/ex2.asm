.MODEL SMALL
.STACK 64
.DATA
NUMAR DW ?
.CODE
EXTRN readInt:PROC
EXTRN writeInt:PROC
START:       	
	MOV AX, @DATA
	MOV DS, AX                       
		
	CALL readInt	; Functie ce citeste un numar pe 2 octeti
	MOV [NUMAR],AX	; Functia returneaza valoarea in AX (binar)

	PUSH [NUMAR]	; Transmit parametru prin stiva (numarul)
	CALL writeInt	; Afisez numarul
	ADD SP,2	; Dezaloc zona de parametrii de pe stiva		

	MOV AH, 4Ch
	INT 21h
	END START
END
