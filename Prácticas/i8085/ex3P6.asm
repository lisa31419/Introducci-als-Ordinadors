.data 00h 
	zero: db 01110111b
	un: db 01000100b
	dos: db 00111110b	
	tres: db 01101110b
	quatre: db 01001101b
	cinc: db 01101011b	
	clear: db 00000000b
.org 24h
	IN 00h 
	SUI 30h
	MOV C, A 
	LDAX B 
	OUT 01h
loop: 
	JMP loop
HLT 