
#Funciones
.globl actualizar_highscore

.data


.text

li $a0,99
jal crear_jugador

#li $a0,5
#jal crear_jugador

#li $a0,4
#jal crear_jugador

#li $a0,3
#jal crear_jugador


jal highscore_str_txt

la $a0,highscore_str
li $a1,100
jal cargar_archivo

li $v0,10
syscall




#*********METODO QUE JUNTA TODO**********#

# $a0 -> puntaje


actualizar_highscore:

addiu $sp,$sp,-8
sw $ra,($sp)


jal crear_jugador

jal highscore_str_txt

la $a0,highscore_str
li $a1,100
jal cargar_archivo


actualizar_highscore_fin:

lw $ra,($sp)
addiu $sp,$sp,8

jr $ra


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

jal controlar_nombre
beqz $v0,pedir_nombre




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

#**************CONTROLAR NOMBRE***************#

controlar_nombre:

li $t0,0
la $t2,jugador_nombre
li $v0,1

controlar_nombre_loop:

beq $t0,3,controlar_nombre_fin

lb $t1,($t2)

blt $t1,65,controlar_nombre_error
bgt $t1,90,controlar_minuscula

j letra_deseada

controlar_minuscula:
blt $t1,97,controlar_nombre_error
bgt $t1,122,controlar_nombre_error

letra_deseada:
li $v0,1

addiu $t0,$t0,1
addiu $t2,$t2,1

j controlar_nombre_loop

controlar_nombre_error:
li $v0,0


controlar_nombre_fin:

jr $ra

#******	CREAR STRING HIGHSCORE PARA TXT*******#

highscore_str_txt:

addiu $sp,$sp,-16
sw $ra,($sp)
sw $s0,4($sp)
sw $s1,8($sp)
sw $s2,12($sp)

la $s0,highscore_str
la $s1,jugadores

#Contador para imprimir 10 rankings
li $s2,0

highscore_str_loop:

beq $s2,10,highscore_str_txt_fin

move $a0,$s2
jal escribir_ranking

addiu $s2,$s2,1

j highscore_str_loop

highscore_str_txt_fin:

lw $ra,($sp)
lw $s0,4($sp)
lw $s1,8($sp)
lw $s2,12($sp)
addiu $sp,$sp,16

jr $ra

#********ESCRIBIR RANKING********#

# $a0 -> ranking en el que estoy

escribir_ranking:

addiu $sp,$sp,-12
sw $ra,($sp)
sw $s0,4($sp)
sw $s1,8($sp)

la $s0,highscore_str
la $s1,jugadores

#Calculo donde escribir en memoria

#Jugadores:
li $t0,4
multu $a0,$t0
mflo $t0

addu $s1,$s1,$t0 #Empiezo en mi ranking

#Highscore str:
li $t0,10 #Ej: 01-ABC-123\n
multu $a0,$t0
mflo $t0
addu $s0,$s0,$t0 #Empiezo en mi ranking



#Escribo numero de ranking

beq $a0,9,escribir_10

#Guardo 0
li $t0,48
sb $t0,($s0)

addiu $s0,$s0,1

#Guardo numero ranking
addiu $t0,$a0,49
sb $t0,($s0)

addiu $s0,$s0,1

j escribir_nombre

escribir_10:

#Guardo 1
li $t0,49
sb $t0,($s0)

addiu $s0,$s0,1

#Guardo 0
li $t0,48
sb $t0,($s0)

addiu $s0,$s0,1

#Por ahora el txt es: 05

escribir_nombre:

#Escribo "-"

li $t0,45
sb $t0,($s0)

addiu $s0,$s0,1

#Loop nombre:

li $t0,0
addiu $s1,$s1,3

escribir_nombre_loop:

beq $t0,3,escribir_puntaje


lb $t2,($s1) #Mi letra

bnez $t2,escribir_nombre_seguir

li $t2,46

escribir_nombre_seguir:

sb $t2,($s0) 
addiu $s0,$s0,1

addiu $t0,$t0,1
addiu $s1,$s1,-1

j escribir_nombre_loop



escribir_puntaje:

#Escribo "-"

li $t0,45
sb $t0,($s0)

addiu $s0,$s0,1


lb $a0,($s1)
jal parse_string

sb $v1,($s0)
addiu $s0,$s0,1
sb $v0,($s0)
addiu $s0,$s0,1


#escribo \n 
li $t0,10
sb $t0,($s0)

escribir_ranking_fin:

lw $ra,($sp)
lw $s0,4($sp)
lw $s1,8($sp)
addiu $sp,$sp,12

jr $ra


#****Parse string******"

# $a0 -> recibe int
# $v0 -> devuelve el primer digito
# $v1 -> devuelve el segundo digito

parse_string:

rem $v0,$a0,10
addiu $v0,$v0,48
div $v1,$a0,10
addiu $v1,$v1,48

parse_string_fin:

jr $ra






