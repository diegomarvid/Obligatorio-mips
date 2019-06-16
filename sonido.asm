.globl sonido_secuencia

.data


.text

#********SONIDO********#

sonido_secuencia:

#en $a0 me llego el color

#Switch:
beq $a0,0,sonido_verde
beq $a0,1,sonido_rojo
beq $a0,2,sonido_azul
beq $a0,3,sonido_amarillo


sonido_verde:

li $v0,31
li $a0,79
li $a1,500
li $a2,5
li $a3,100
syscall

j sonido_secuencia_fin

sonido_rojo:

li $v0,31
li $a0,64
li $a1,500
li $a2,5
li $a3,100
syscall

j sonido_secuencia_fin

sonido_azul:

li $v0,31
li $a0,67
li $a1,500
li $a2,5
li $a3,100
syscall

j sonido_secuencia_fin

sonido_amarillo:

li $v0,31
li $a0,72
li $a1,500
li $a2,5
li $a3,100
syscall

j sonido_secuencia_fin


sonido_secuencia_fin:

jr $ra
