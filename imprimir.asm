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

addiu $sp,$sp,-12
sw $ra,($sp)
sw $s0,4($sp)
sw $s2,8($sp)

la $s0, ($a1)
move $s2, $a0 #Numero de turno, se usa para saber cuantas veces imprimir

loop:

beqz $s2, imprimir_fin

lb $t1,($s0)

li $v0,1
move $a0,$t1
syscall

move $a0,$t1
jal sonido_secuencia


addiu $s2,$s2,-1
addiu $s0,$s0,1

j loop


imprimir_fin:

lw $ra,($sp)
lw $s0,4($sp)
lw $s2,8($sp)
addiu $sp,$sp,12
jr $ra

#---------------------------------------------------------------

volver_jugar:

li $v0,4
la $a0,decisionstr
syscall

li $v0,4
la $a0,instruccionstr
syscall

li $v0,5
syscall

jr $ra

#---------------------------------------------------------------------

