; afiseaza mesajul din 'HI'

.MODEL SMALL
.STACK 32
.DATA
HI DB "Hello World!$" 	; define a message
.CODE 
START: 
	MOV AX,@DATA
	MOV DS,AX
	
	CALL Hello 	; Call the procedure
	MOV AX,4C00h 		; return to DOS
	INT 21h 		

	Hello PROC 

	MOV DX,OFFSET HI 
	MOV AH,9 
	INT 21h 

	RET
	Hello ENDP 

END START