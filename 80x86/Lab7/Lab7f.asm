.MODEL SMALL
.CODE
PUBLIC SUM
SUM PROC
	PUSH BP 	; save bp
	MOV BP,SP 	; put sp into bp
	
	XOR AX, AX	; clear ax 
	ADD AX, [BP+4]
	ADD AX, [BP+6]
	
	POP BP
	
	RET
SUM ENDP
END