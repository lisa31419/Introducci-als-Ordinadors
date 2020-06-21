.define 					; Número de carácteres permitidos
	allowed_count 15 
.data 00h 				; Carácteres Permitidos:
	allowed: db 30h,31h,32h,33h,34h,35h,36h,37h,38h,39h,2Bh,2Dh,26h,7Ch,3Dh 

.org 100h 
	pila: 				; Posición Pila


.org 200h				; Programa Principal 
	lxi H, pila 			; Puntero de pila apuntando a 100h
	sphl 
	mvi B, E0h 			; Par BC apuntando
	mvi C, 00h 			; a la memoria de texto
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
		cpi 3DH
		jz and
		jmp end_allowed 

	not_allowed: 				; No Permitido: Poner a 00h
		mvi A,00h 

	end_allowed: 
		pop H 
		pop D 
		ret

and:
	STAX B
	DCX B
	LDAX B

	MOV E,A	

	DCX B
	DCX B 
	LDAX B

	ANA E
	INX B
	INX B
	 INX B
	INX B
	

imprimir:
	STAX B 
	INX B	
	MVI A, 20H
	JMP end_allowed


	
