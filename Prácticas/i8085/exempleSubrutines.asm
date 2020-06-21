.data 20h
	kk: db 3,4,5
.org 100h

mvi b, 3
mvi h, 0
mvi l, 20h
bucle:
	mov a, M
	inx h
	dcr b
	jnz bucle

	call varia
hlt

varia:
	push h
	push psw
bucle2:

	inr b
	dcr l
	jnz bucle2
	pop psw
	pop h
	ret
