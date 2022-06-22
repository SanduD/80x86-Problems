;passing parameter through register (afiseaza DL)
.MODEL SMALL
.STACK 32
.DATA
.CODE 
START: 
	MOV AX,@DATA
	MOV DS,AX
	MOV DL,'a'
	
	CALL PrintChar 	; call the procedure
	MOV AX,4C00h 	; return to DOS
	INT 21h 		

	PrintChar PROC

	MOV AH,2 
	INT 21h 

	RET
	PrintChar ENDP 

END START