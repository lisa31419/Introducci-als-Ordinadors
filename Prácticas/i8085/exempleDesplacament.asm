.define
contador 08
.data 50h
valor: db 55h

.org 100h
	lda valor
	mvi c,contador
loop1:
	rlc
	dcr c
	jp loop1
	mvi c, contador
loop2:
	rrc
	dcr c
	jp loop2
	hlt
