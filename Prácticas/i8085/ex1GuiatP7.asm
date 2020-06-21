.org 100h 
pila: 					; Posición Pila

.org 200h 				; Programa Principal 
	lxi H, pila 			; Puntero de pila apuntando a 100h
	sphl 
	mvi B, E0h 			; Par BC apuntando
	mvi C, 00h 			; a la memoria de texto
bucle: 
	jmp bucle 			; Loop infinito

.org 0024h 				; Dirección de interrupción TRAP
	call string_in 		; Llmada a subrutina de introducción
	ret 				; de datos por consola

.org 300h 				; Rutina captura y muestra 
string_in: 
	in 00h 			; Puerto de entrada 
	cpi 00h 			; Si no hay carácter introducido, sale
	jz no_tecla 			; Si hay, escríbelo por pantalla

tecla: 
	stax B 
	inx B 

no_tecla: 
	ret