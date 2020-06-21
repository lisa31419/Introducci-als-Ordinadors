.define 					; Nombre de car�cteres permitidos
	allowed_count 15 
.data 00h 					; Car�cteres Permitidos:0-9, +, -, &, |, = 
	allowed: db 30h, 31h, 32h, 33h, 34h, 35h ,36h, 37h, 38h, 39h, 2Bh, 2Dh, 26h, 7Ch, 3Dh 
.org 100h 
	pila: 					; Posici�n Pila

.org 200h					; Programa Principal 
	lxi H, pila 				; Puntero de pila apuntando a 100h
	sphl 
	mvi B, E0h 				; Par BC apuntando
	mvi C, 00h 				; a la memoria de texto
bucle: 
	jmp bucle				; Loop infinito

.org 0024h 					; Direcci�n de interrupci�n TRAP
	call string_in 			; Lllamada a subrutina de introducci�n
	ret 					; de datos por consola

.org 300h 					; Rutina captura y muestra 
string_in: 
	in 00h 				; Puerto de entrada 
	cpi 00h 				; Si no hab�a car�cter introduido, sale
	jz no_tecla 				; Si habia, comprueba que est� 								  permitido
tecla: 
	call check_allowed 		; Car�cter Permitido? Si no 00h
	cpi 00h 				; Escribidlo
	jz no_tecla 
	stax B 
	inx B 
no_tecla: 
	ret

check_allowed: 				; Subrutina control car�cteres
	push D 
	push H 
	mvi E, allowed_count 
	lxi H, allowed 

allowed_loop: 				; Comprueba si el car�cter est� en
	mov D,M 				; la lista de car�cteres permitidos
	cmp D 
	jz is_allowed 
	inx H 
	dcr E 	
	jnz allowed_loop 
	jmp not_allowed 
is_allowed: 					; Est� Permitido: No modificar
	mov A,D 
	jmp end_allowed 

not_allowed: 				; No Permitido: Poner a 00h
	mvi A,00h 

end_allowed: 
	pop H 
	pop D 
	ret