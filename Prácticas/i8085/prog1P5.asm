.define
	num 5
.data 00h
	mat1: db 1,2,3,4,5
	mat2: db 6,7,8,9,0
	mat3: db 0,0,0,0,0
.org 100h
	LXI H, mat1		; HL <= 00h (cargamos la posición 00h 				inicicialmente)
	LXI B, mat2		; BC <= 05h (cargamos la posición 05h 				inicialmente)
	MVI D, num		; D <= 5 (cargamso el inmediato 5)
loop:
	MOV E, M	; cargamos el contenido de la dirección 				00h (inicialmente, 1) en el registro E 
	LDAX B	;guardo en acumulador el contenido de par de 			registros BC (direccionamiento indirecto)
	ADD E	; sumo acumulador y el contenido del registro 			E, guardando el resultado en acumulador
	STAX B	; guardo la suma en la posición donde había 			inicialmente un 6 (posición 05h)
	INX H		; incrementamos el par HL
	INX B		; incrementamos el par BC
	DCR D	; decrementamos el registro D
	JNZ loop	; mientras no sea 0, saltamos a loop
hlt