.define
	num 02h
.data 00h
	mat1: db 1,2
	mat2: db 3,4
	mat3: db 0,0
.data 20h
	pila:
.org 600h
	LXI H, pila
	SPHL
	MVI A, num		; A <= num = 2
	LXI D, mat1		; DE <= mat1
	LXI H, mat2		; HL <= mat2
	LXI B, mat3		; BC <= mat3
loop:
	CALL suma
	DCR A
	JNZ loop
	NOP
	HLT
suma:
	PUSH PSW
	LDAX D			; A <= [DE]
	ADD M			; A <= [HL]
	STAX B			; [BC] <= A
	INX H			; HL ++
	INX D			; DE ++
	INX B			; BC ++
	POP PSW
	RET