
.data 100h
	pila:
.org 24h 
	 CALL ports 
	RET
.org 500h
	LXI H, pila 
	SPHL 
	CALL ports
	NOP
loop:
	JMP loop
ports: 
	PUSH PSW 
	IN 04h 
	ANI 00000001
	OUT 05h 
	POP PSW 
	RET 