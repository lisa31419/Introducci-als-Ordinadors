.define 					; Número de carácteres permitidos
	allowed_count 15 
	contador_x10 9
	contador_x100 99
.data 00h 				; Carácteres Permitidos:
	allowed: db 30h,31h,32h,33h,34h,35h,36h,37h,38h,39h,2Bh,2Dh,26h,7Ch,3Dh 

.org 100h 
	pila: 				; Posición Pila


.org 200h				; Programa Principal 
	lxi H, pila 			; Puntero de pila apuntando a 100h
	sphl 
	mvi B, E0h 			; Par BC apuntando
	mvi C, 00h 			; a la memoria de texto
	call imprimir_espacio
bucle: 
	jmp bucle			; Loop infinito


.org 0024h 				; Dirección de interrupción TRAP
	call string_in 			; Lllamada a subrutina de introducción
	ret 				; de datos por consola


.org 300h 				; Rutina captura y muestra 
string_in: 
	in 00h 				; Puerto de entrada 
	cpi 00h 				; Si no había carácter introduido, sale
	jz no_tecla 			; Si habia, comprueba que está  permitido
tecla: 
	call check_allowed 		; Carácter Permitido? Si no 00h
	cpi 00h 				; Escribidlo
	jz no_tecla 
	stax B 
	inx B 
	cpi 3DH
	jz buscar_operacion
	ret
no_tecla: 
	ret

check_allowed: 				; Subrutina control carácteres
	push D 
	push H 
	mvi E, allowed_count 		; CONTADOR
	lxi H, allowed 			; lista de nums y signos

	allowed_loop: 			; Comprueba si el carácter está en la lista de carácteres permitidos
		mov D,M 				
		cmp D 
		jz is_allowed 
		inx H 
		dcr E 				
		jnz allowed_loop 		;HASTA QUE E <= 0
		jmp not_allowed 		; SI E == 0
	is_allowed: 				; Está Permitido: No modificar
		mov A,D 
		jmp end_allowed 

	not_allowed: 				; No Permitido: Poner a 00h
		mvi A,00h 

	end_allowed: 
		pop H 
		pop D 
		ret

.org 500H
buscar_operacion:
	MOV H, B
	MOV L, C

	
	DCX H		
	DCX H
	MOV A, M
	SUI 30H
	MOV E, A
	DCX H

	CALL check_if_symbol
	CPI 00H
	JZ salta

	CALL multiplicar_x10
	ADD E
	MOV E, A
	DCX H

	CALL check_if_symbol
	CPI 00H
	JZ salta

	CALL multiplicar_x100
	ADD E
	MOV E, A
	DCX H

	

salta:
	DCX H
	MOV A, M
	SUI 30H
	MOV D, A
	
	DCX H
	MOV A, M
	
	CPI 0DH
	JZ incrementar_x2

	MOV  A, M
	CALL multiplicar_x10
	ADD D
	MOV D, A

	DCX H
	MOV A, M

	CPI 0DH
	JZ incrementar

	MOV A, M
	CALL multiplicar_x100
	ADD D
	MOV D, A

incrementar:
	INX H

incrementar_x2:
	INX H
	INX H


	MOV A, M
	
	CPI 2BH
	JZ suma

	CPI 2DH
	JZ resta

	CPI 26H
	JZ and

	CPI 7CH
	JZ or 
	
	JMP imprimir_espacio
	ret

	

.org 600H
check_if_symbol:

	MOV A, M
	CPI 2BH
	JZ allowed_symbol

	CPI 2DH
	JZ allowed_symbol

	CPI 26H
	JZ allowed_symbol

	CPI 7CH
	JZ allowed_symbol

	ret 

allowed_symbol:
	mvi A, 00h
	ret


.org 700h
suma:
	MOV A, D
	ADD E
	CALL num_cifras
	CALL imprimir_espacio
	MVI A, 00H 
	ret

.org 800H
resta:
	
	MOV A, D
	SUB E
	JP es_positivo
	CALL signo
es_positivo:
	CALL num_cifras
	CALL imprimir_espacio
	MVI A, 00H 
	ret
	

.org 900H	
signo:
	MOV A, E
	SUB D 
	PUSH PSW
	MVI A, 2DH
	STAX B
	INX B
	POP PSW
	ret



.org A00H
and:
	MOV A, D
	ANA E
	CALL num_cifras
	CALL imprimir_espacio
	MVI A, 00H 
	ret

.org B00H
or:
	MOV A, D
	ORA E
	CALL num_cifras
	CALL imprimir_espacio
	MVI A, 00H 
	ret


.org C00H
multiplicar_x10:
	PUSH D
	SUI 30H
	MVI D, contador_x10

bucle_multiplicar_x10:
	ADD M
	SUI 30H
	DCR D
	JNZ bucle_multiplicar_x10
	
	POP D
	ret

multiplicar_x100:
	PUSH D
	SUI 30H
	MVI D, contador_x100

bucle_multiplicar_x100:
	ADD M
	SUI 30H
	DCR D
	JNZ bucle_multiplicar_x100
	
	POP D
	ret

	
	
.org D00H
num_cifras:
	PUSH D
	PUSH H
	MOV H, A

	SUI 64H
	JP tres_cifras
	ADI 64H

	SUI 0AH
	JP dos_cifras
	ADI 0AH

	JMP una_cifra

tres_cifras:
	MVI D, 00H        ; CONTADOR

compactar_centenas:
	INR D
	SUI 64H
	JP compactar_centenas

	ADI 64H
	MOV H, A
	MOV A, D

	ADI 30H
	STAX B
	INX B

	MOV A, H

	SUI 0AH		; COMPROBAMOS SI EL RESULTADO JUSTO ES 0
	MVI D, 00H
	JM cifra_cero

dos_cifras:
	MVI D, 00H

compactar_decenas:
	INR D
	SUI 0AH
	JP compactar_decenas

cifra_cero:
	ADI 0AH
	MOV H, A
	MOV A, D

	ADI 30H
	STAX B
	INX B
	MOV A, H


una_cifra:
	ADI 30H
	STAX B
	INX B

	POP H
	POP D
	RET
	




.org E00H
imprimir_espacio:
	PUSH PSW
	MVI A, 0DH
	STAX B 
	INX B	
	POP PSW
	ret
 



