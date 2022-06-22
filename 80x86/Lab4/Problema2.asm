	DOSSEG
	.MODEL SMALL
	.STACK 32
	.DATA
NUMAR DB 0 ;1
NUMERE  DB  0Dh,0Ah,'mat(1,1)=$' ;12
M DB 2 ;1
N DB 2 ;1
KBD	DB  7,0,0,0,0,0,0,0,0 ;9
TWO_POWER   DW 32,16,8,4,2,1 ; 12
STORE	DB 81 DUP (20h); ad inceput 25+12=37
	.CODE
START:	MOV AX,@DATA
	MOV DS,AX

	XOR CX,CX
	MOV CL,[M]; nr linii
	MOV DI,OFFSET STORE
    PUSH DI

;afisare sir interogare

COLOANE:
    PUSH CX
    XOR CX,CX
    MOV CL,[N] ; nr cols
    ;;salvare offset store
LINIE:
    PUSH CX
    PUSH DI
    MOV DX,OFFSET NUMERE
	MOV AH,9
	INT 21H
	INC [NUMERE+8]

	MOV [KBD+1],0
	MOV AH,0Ah
	MOV DX,OFFSET KBD; citesc valoare ascii a nr binar
	INT 21H	

	MOV CL,[KBD+1]
	MOV CH,0 ; contor cu nr de caractere
	MOV SI,(OFFSET KBD)+2
    MOV DI, OFFSET TWO_POWER
    
    xor AX,AX
    Convert:
        ADD [Numar],AL
        MOV DH,0
        
    ASCII_binary:
        MOV DL, [SI] ;;offset nr citit
        SUB DX,30h
        MOV AX, DX
        XOR BX,BX
        MOV BL,[DI]
        MUL BX
        INC SI
        INC DI
        LOOP Convert

    POP DI

    MOV AL,[NUMAR]
    MOV [DI],AL
    INC DI
    MOV [NUMAR],0

    POP CX
	LOOP LINIE
    INC [NUMERE+6]
    MOV [NUMERE+8],31h
    POP CX
    LOOP COLOANE
	;

	MOV AH,4CH
	INT 21H
	;
CRLF:	
MOV AH,2
	MOV DL,0Ah
	INT 21h
	MOV AH,2
	MOV DL,0Dh
	INT 21h
	RET
	;
	END START

