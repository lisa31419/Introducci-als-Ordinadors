.define
	num 5
.data 00h
	mat1: db 1,2,3,4,5
	mat2: db 6,7,8,9,0
	mat3: db 0,0,0,0,0
.org 100h
	LXI B, mat1	; BC <= 00h (cargamos la posición 00h 				inicicialmente) [ 10 ciclos]
	LXI D, mat3	; DE <= 0Ah (cargamos la posición 0Ah 				inicicialmente) [ 10 ciclos]
	MVI H, num		; H <= 5 (cargamos el inmediato 5)     				[ 7 ciclos]

loopCopia:			; copiamos mat 1 en mat 3
	LDAX B		;guardamos en acumulador el contenido 				de par de registros BC 	[ 7 ciclos]					(direccionamiento indirecto)
	STAX D		; guardo acumulador en la posición 					en DC [ 7 ciclos]
	INX B			; incrementamos el par BC [ 6 ciclos]
	INX D			; incrementamos el par DE [ 6 ciclos]
	DCR H		; decrementamos el registro H [4 ciclos]
	JNZ loopCopia	; mientras H != 0, saltamos a loopCopia
				[ 7 o 10 ciclos, según si saltamos o no ]
	LXI H, mat2	; HL <= 05h (cargamos la posición 05h 				inicicialmente) [ 10 ciclos]
	LXI B, mat3	; BE <= 0Ah (cargamos la posición 0Ah 				inicicialmente) [ 10 ciclos]
	MVI D, num		; D <= 5 (cargamos el inmediato 5)    				[ 7 ciclos]

loop:
	MOV E, M		; cargamos el contenido de la dirección 				05h (inicialmente, 6) en el registro E   				[ 7 ciclos]
	LDAX B		;guardamos en acumulador el contenido 				de par de registros BC [ 7 ciclos]					(direccionamiento indirecto)
	ADD E		; sumo acumulador y el contenido del 				registro E, guardando el resultado en 				acumulador [ 7 ciclos]
	STAX B		; guardo la suma en la posición donde 				había	inicialmente un 1 (posición 0Ah) 				[ 7 ciclos]
	INX H			; incrementamos el par HL [ 6 ciclos]
	INX B			; incrementamos el par BC [ 6 ciclos]
	DCR D		; decrementamos el registro D            				[ 4 ciclos]
	JNZ loop		; mientras no sea 0 saltamos a loop    				 [ 7 o 10 ciclos, según si saltamos o no ]

hlt				; fin del programa [ 4 ciclos]