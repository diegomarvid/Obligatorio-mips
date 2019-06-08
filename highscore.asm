.globl jugadores
.globl highscores_str

.data

#Creo poisicion en memoria para guardar el jugador y su highscore
#A(1b)A(2b)A(3b)Puntaje(4b)

jugadores: .space 40
highscores_str: .space 80


jugador_nombre: .space 4

ingreso_nombre_str: .asciiz "Ingrese nombre de jugador: " 


jugador_actual: .word

.text

li $a0,3
jal crear_jugador

li $a0,5
jal crear_jugador

li $a0,4
jal crear_jugador

li $a0,3
jal crear_jugador


li $v0,10
syscall




#**********AGREGAR HIGHSCORE*************#

# $a0 -> direccion memoria jugador


agregar_highscore:

addiu $sp,$sp,-24
sw $ra,($sp)
sw $s0,4($sp)
sw $s1,8($sp)
sw $s2,12($sp)
sw $s3,16($sp)
sw $s4,20($sp)

lb  $s3,jugador_actual #Puntaje

#la $s4,$a0

#Comparo para ver si es highscore
la $s0,jugadores
#Accedo a la ultima posicion
#rank 10
addiu $s0,$s0,36

# Contador para saber en que ranking estoy comparando
li $s2,1

agregar_highscore_loop:

bgt $s2,10,agregar_highscore_fin

#Cargo puntaje del rank
lb $s1,($s0)
#Comparo para ver si remplazarlo
ble $s3,$s1,agregar_highscore_fin


move $a0,$s3
la $a1,jugador_actual
move $a2,$s2
jal swap_rank 

addiu $s0,$s0,-4
addiu $s2,$s2,1

j agregar_highscore_loop

agregar_highscore_fin:

lw $ra,($sp)
lw $s0,4($sp)
lw $s1,8($sp)
lw $s2,12($sp)
lw $s3,16($sp)
lw $s4,20($sp)
addiu $sp,$sp,24
jr $ra

#**********CAMBIAR RANKING**********#

# $a0 -> puntaje
# $a1 -> direccion de memoria nombre
# $a2 -> posicion de ranking actual para comparar

swap_rank:

#Caso de borde
beq $a2,1,swap_rank_remplazar

#Calculo posicion de memoria actual
la $t0,jugadores
addiu $t0,$t0,39 #Ultima posicion rank 10

#Calculo cuanto me tengo que mover para atras

addiu $a2,$a2,-1 # para empezar al final de la word

li $t1,4
multu $a2,$t1
mflo $t1

#Donde tengo que ir mi rank nuevo
subu $t0,$t0,$t1

li $t1,0

#swap
swap_rank_loop:



beq $t1,4,swap_rank_seguir

lb $t2,($t0) 
sb $t2,4($t0)

addiu $t0,$t0,-1
addiu $t1,$t1,1

j swap_rank_loop


swap_rank_seguir:

#Sumo uno para empezar desde el ultimo
#byte del word asi ya empiezo pegando
addiu $t0,$t0,1

#Pego mi highscore

li $t2,0

swap_rank_loop_usuario:

beq $t2,4,swap_rank_fin

lb $t1,($a1)
sb $t1,($t0)

addiu $t2,$t2,1
addiu $t0,$t0,1
addiu $a1,$a1,1

j swap_rank_loop_usuario

swap_rank_remplazar:

#Cargo en el ranking 10

li $t2,0

la $t0,jugadores
addiu $t0,$t0,36

swap_rank_remplazar_loop:

beq $t2,4,swap_rank_fin

lb $t1,($a1)
sb $t1,($t0)

addiu $t2,$t2,1
addiu $t0,$t0,1
addiu $a1,$a1,1

j swap_rank_remplazar_loop

swap_rank_fin:

jr $ra

#********Crear jugador*******#

# $a0 -> puntaje

crear_jugador:

addiu $sp,$sp,-8
sw $ra,($sp)
sw $s0,4($sp)

move $s0,$a0


#Pido el nombre
pedir_nombre:

li $v0,54
la $a0,ingreso_nombre_str
la $a1,jugador_nombre
li $a2,4
syscall

bnez $a1,pedir_nombre

move $a0,$s0
jal ingresar_jugador_sistema


jal agregar_highscore


crear_jugador_fin:


lw $ra,($sp)
lw $s0,4($sp)
addiu $sp,$sp,8
jr $ra

#*****INGRESAR JUGADOR SISTEMA******#


# $a0 -> puntaje jugador
# Modifica jugador actual

ingresar_jugador_sistema:


#agrego nombre al jugador actual
la $t0,jugador_nombre


#Pongo en el formato deseado
li $t1,0
la $t3,jugador_actual
addiu $t3,$t3,3

ingresar_jugador_sistema_loop:

beq $t1,3,ingresar_jugador_sistema_fin

lb $t2,($t0)
sb $t2,($t3)

addiu $t1,$t1,1
addiu $t0,$t0,1
addiu $t3,$t3,-1

j ingresar_jugador_sistema_loop

ingresar_jugador_sistema_fin:

sb $a0,($t3)

jr $ra










