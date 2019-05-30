.globl imprimir_secuencia
.globl volver_jugar

.data

decisionstr: .asciiz "\nDesea volver a jugar? \n"
instruccionstr: .asciiz "Apriete 1 si quiere volver a jugar, de lo contratrio apriete 0: \n"

.text

#--------------------------------------------------------------

#en $a0 recibo turno
#en $a1 recibo secuencia

imprimir_secuencia:

addiu $sp,$sp,-16
sw $ra,($sp)
sw $s0,4($sp)
sw $s2,8($sp)
sw $s3,12($sp)

la $s0, ($a1)
move $s2, $a0 #Numero de turno, se usa para saber cuantas veces imprimir

loop:

beqz $s2, imprimir_fin

lb $s3,($s0) #Valor de la secuencia para mostrar



#li $v0,1
move $a0,$s3
jal display_light
#syscall

move $a0,$s3
jal sonido_secuencia


addiu $s2,$s2,-1
addiu $s0,$s0,1

j loop


imprimir_fin:

lw $ra,($sp)
lw $s0,4($sp)
lw $s2,8($sp)
lw $s3,12($sp)
addiu $sp,$sp,16
jr $ra

#---------------------------------------------------------------

volver_jugar:

li $v0,50
la $a0,decisionstr
syscall

move $v0,$a0

jr $ra

#---------------------------------------------------------------------

