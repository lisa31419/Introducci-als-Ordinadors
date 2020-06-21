.define
	num 5
	clau 55h
.data 00h
	mat1: db 1,2,3,4,5
	mat2: db 6,7,8,9,0
	mat3: db 0,0,0,0,0
.org 100h
	LXI H, mat1		; HL <= 00h (cargamos la posición 00h 				inicicialmente)
	LXI B, mat2		; BC <= 05h (cargamos la posición 05h 				inicialmente)
	MVI D, num		; D <= 5 (cargamos el inmediato 5)
loop:
	MOV E, M	; cargamos el contenido de la dirección 				00h (inicialmente, 1) en el registro E 
	LDAX B	;guardo en acumulador el contenido de par de 			registros BC (direccionamiento indirecto)
	ADD E	; sumo acumulador y el contenido del registro 			E, guardando el resultado en acumulador
	STAX B	; guardo la suma en la posición donde había 			inicialmente un 6 (posición 05h)
	INX H		; incrementamos el par HL
	INX B		; incrementamos el par BC
	DCR D	; decrementamos el registro D
	JNZ loop	; mientras no sea 0, saltamos a loop
	call encripta ; guardamos el contenido de PC en la pila
hlt

.org 25h
encripta:	; encriptamos el resultado y lo guardamos en mat3
	PUSH psw		; guarda el contenido de AF en la pila
	PUSH H		; guarda el contenido de HL en la pila
	PUSH	B		; guarda el contenido de BC en la pila
	PUSH	D		; guarda el contenido de DE en la pila
	MVI E, num 		; E <= 5 (cargamos el inmediato 5)
	LXI H, mat2		 ; HL <= 05h (cargamos la posición 05h 				inicicialmente)
	LXI B, mat3		 ; HL <= 0Ah (cargamos la posición 0Ah 				inicicialmente)
	sloop:
		MOV A,M	; guardamos el 1º valor de mat2 en 				acumulador
		XRI clau	; hacermos Acumulador XOR clau
		STAX B	; guardo la suma en la posición 0Ah
				inicialmente
		INX H		; incrementamos el par HL
		INX B		; incrementamos el par BC
		DCR E	; decrementamos el registro E
		JNZ sloop	; mientras no sea 0, saltamos a sloop	
		POP D	; retornamos el par de registros DE
		POP B		; retornamos el par de registros BC
		POP H	; retornamos el par de registros HL
		POP psw	; retornamos el par de registros AF
		ret		; retornamos el PC (estructura LIFO)