.globl sonido_secuencia

.data


.text

#------------------------------------------------------------

sonido_secuencia:

#en $a0 me llego el color

beq $a0,0,sonido_verde
beq $a0,1,sonido_rojo
beq $a0,2,sonido_azul
beq $a0,3,sonido_amarillo


sonido_verde:

li $v0,33
li $a0,60
li $a1,500
li $a2,5
li $a3,100
syscall

j sonido_secuencia_fin

sonido_rojo:

li $v0,33
li $a0,69
li $a1,500
li $a2,5
li $a3,100
syscall

j sonido_secuencia_fin

sonido_azul:

li $v0,33
li $a0,64
li $a1,500
li $a2,5
li $a3,100
syscall

j sonido_secuencia_fin

sonido_amarillo:

li $v0,33
li $a0,61
li $a1,500
li $a2,5
li $a3,100
syscall

j sonido_secuencia_fin


sonido_secuencia_fin:

jr $ra