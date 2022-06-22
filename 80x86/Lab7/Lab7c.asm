;;passing parameter through memory (afiseaza ce exista in 'Char')
.MODEL SMALL
.STACK 32
.DATA
Char DB ?
.CODE 
START: 
	MOV AX,@DATA
	MOV DS,AX
	MOV [Char],'a'
	
	CALL PrintChar 	; Call the procedure
	MOV AX,4C00h 		; return to DOS
	INT 21h 		

	PrintChar PROC
	MOV DL, [Char]
	MOV AH,2 
	INT 21h 

	RET
	PrintChar ENDP 

END START