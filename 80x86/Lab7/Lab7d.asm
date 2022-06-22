;;passing parameter through stack
.MODEL SMALL
.STACK 32
.DATA
Char DB ?
.CODE 
START: 
	MOV AX,@DATA
	MOV DS,AX
	MOV DL,'a'
	PUSH DX
	
	CALL PrintChar 	; Call the procedure
	MOV AX,4C00h 		; return to DOS
	INT 21h 		

	PrintChar PROC
					;prolog
	PUSH BP			;save bp
	MOV BP, SP		;put sp into bp
	
	MOV DX, [BP+4]
	MOV AH,2 
	INT 21h 
					;epilog
	POP BP

	RET
	PrintChar ENDP 

END START