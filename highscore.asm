
#Funciones
.globl actualizar_highscore
.globl highscore_str_txt
.data


.text

#*********METODO UNION DE TODOS**********#
# En $a0 recibe el puntaje del jugador.
actualizar_highscore:
addiu $sp,$sp,-8
sw $ra,($sp)

#Creo un jugador con el puntaje asociado y analizo si entra en el highscore.
jal crear_jugador
#Actualiza el texto del archivo highscore.txt
jal highscore_str_txt

#Carga el archivo con el txt actualizado.
la $a0,highscore_str
li $a1,100
jal cargar_archivo

actualizar_highscore_fin:

lw $ra,($sp)
addiu $sp,$sp,8

jr $ra


#**********AGREGAR HIGHSCORE*************#

agregar_highscore:
addiu $sp,$sp,-24
sw $ra,($sp)
sw $s0,4($sp)
sw $s1,8($sp)
sw $s2,12($sp)
sw $s3,16($sp)
sw $s4,20($sp)

#Cargo el puntaje del jugador actual.
lb  $s3,jugador_actual


#Comienzo a recorrer el array de jugadores desde el ultimo puntaje (Rank 10).
la $s0,jugadores
addiu $s0,$s0,36

# Contador para saber en que posicion del ranking estoy comparando al jugador actual.
li $s2,1

agregar_highscore_loop:
#Cuando compare a todas las posiciones del ranking termino.
bgt $s2,10,agregar_highscore_fin

#Cargo puntaje de la posiocn del ranking.
lb $s1,($s0)

#Si el puntaje del jugador actual es menor al de la posicion analizada entonces termine..
ble $s3,$s1,agregar_highscore_fin

#Si es mayor entonces intercambian posiciones entre si los jugadores.
move $a0,$s3
la $a1,jugador_actual
move $a2,$s2
jal swap_rank 

#Apunto al puntaje del proximo jugador.
addiu $s0,$s0,-4
#Aumento las comparaciones realizadas en uno.
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

#En caso de tener que swapear en la posicion 10 se hace un caso de borde.
beq $a2,1,swap_rank_remplazar

#Calculo posicion de memoria actual en donde se comienza a pegar.
#$t0=Posicion=Inicio_array_jugadores+39-(Cant_comp-1)*4

la $t0,jugadores
addiu $t0,$t0,39
addiu $a2,$a2,-1

li $t1,4
multu $a2,$t1
mflo $t1
#Donde arranca el jugador a swapear.
subu $t0,$t0,$t1

#Loop el cual permite cambiar el puntaje a la izquiera hacia la derecha.
#Contador auxiliar.
li $t1,0
swap_rank_loop:
#Mientras la cantidad de datos swapeados sea menor a 4 sigo.
beq $t1,4,swap_rank_seguir

#Muevo el valor 4 bytes mas adelante.
lb $t2,($t0) 
sb $t2,4($t0)

#Actualizo los punteros y el contador.
addiu $t0,$t0,-1
addiu $t1,$t1,1
j swap_rank_loop

#Coloco el jugador de la derecha a la izquierda.
swap_rank_seguir:

#Sumo uno para empezar desde el ultimo byte del word asi ya empiezo pegando
addiu $t0,$t0,1

#Loop el cual permite cambiar el puntaje de la derecha hacia la izquierda.
#Contador auxiliar.
li $t2,0

swap_rank_loop_usuario:
#Mientras la cantidad de datos swapeados sea menor a 4 sigo.
beq $t2,4,swap_rank_fin
#Dado que arranque el la posicion correcta es solo pegar uno a uno los datos.
lb $t1,($a1)
sb $t1,($t0)
#Actualizo los punteros y el contador.
addiu $t2,$t2,1
addiu $t0,$t0,1
addiu $a1,$a1,1

j swap_rank_loop_usuario

#Caso de borde (Lugar 10 del ranking)
swap_rank_remplazar:

#Cargo en el ranking 10



#Cargo la posicion de donde se comienza a pegar.
la $t0,jugadores
addiu $t0,$t0,36

#Contador auxiliar.
li $t2,0
swap_rank_remplazar_loop:
#Mientras la cantidad de datos swapeados sea menor a 4 sigo.
beq $t2,4,swap_rank_fin

#Dado que arranque el la posicion correcta es solo pegar uno a uno los datos.
lb $t1,($a1)
sb $t1,($t0)

#Actualizo los punteros y el contador.
addiu $t2,$t2,1
addiu $t0,$t0,1
addiu $a1,$a1,1

j swap_rank_remplazar_loop

swap_rank_fin:

jr $ra

#***************CREAR JUGADOR**************#
# $a0 -> puntaje
crear_jugador:

addiu $sp,$sp,-8
sw $ra,($sp)
sw $s0,4($sp)

move $s0,$a0

#Pido el nombre.
pedir_nombre:

li $v0,54
la $a0,ingreso_nombre_str
la $a1,jugador_nombre
li $a2,4
syscall
#Controlo el formato del nombre(3 letras juntas)
bnez $a1,pedir_nombre
jal controlar_nombre
beqz $v0,pedir_nombre

#Agrego el jugador al sistema.
move $a0,$s0
jal ingresar_jugador_sistema

#Al jugador creado analizo si esta en el highscore.
jal agregar_highscore
crear_jugador_fin:

lw $ra,($sp)
lw $s0,4($sp)
addiu $sp,$sp,8
jr $ra


#*****INGRESAR JUGADOR SISTEMA******#

# $a0 -> puntaje jugador
# Modifica el espacio del jugador actual.
ingresar_jugador_sistema:

#Agrego nombre al jugador actual
la $t0,jugador_nombre

#Pongo en el formato deseado

la $t3,jugador_actual
addiu $t3,$t3,3
#Contador auxiliar.
li $t1,0
ingresar_jugador_sistema_loop:
#Mientras la cantidad de letras del nombre pegadas sea menor a 3 sigo.
beq $t1,3,ingresar_jugador_sistema_fin
#Muevo la letra del nombre al espacio del jugador.
lb $t2,($t0)
sb $t2,($t3)

#Muevo los punteros y los contadores.
addiu $t1,$t1,1
addiu $t0,$t0,1
addiu $t3,$t3,-1

j ingresar_jugador_sistema_loop


ingresar_jugador_sistema_fin:
#Cargo en la ultima posicion el puntaje del jugador.
sb $a0,($t3)
jr $ra

#**************CONTROLAR NOMBRE***************#

controlar_nombre:

li $t0,0
la $t2,jugador_nombre
li $v0,1
#Se fija si cada letra es una letra minuscula o mayuscula.
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


#****************CREAR STRING HIGHSCORE PARA TXT**************#
highscore_str_txt:

addiu $sp,$sp,-16
sw $ra,($sp)
sw $s0,4($sp)
sw $s1,8($sp)
sw $s2,12($sp)

la $s0,highscore_str
la $s1,jugadores

#Contador para crear las 10 posiciones del ranking.
li $s2,0

highscore_str_loop:
#Si ya cree las 10 posiciones del ranking txt entonces termino.
beq $s2,10,highscore_str_txt_fin

#Escrico la posicion del ranking actual.
move $a0,$s2
jal escribir_ranking

#Aumento la posicion del ranking a escribir.
addiu $s2,$s2,1
j highscore_str_loop

highscore_str_txt_fin:

lw $ra,($sp)
lw $s0,4($sp)
lw $s1,8($sp)
lw $s2,12($sp)
addiu $sp,$sp,16

jr $ra



#***********ESCRIBIR RANKING**********#

# $a0 ->posicion del ranking en el que estoy

escribir_ranking:

addiu $sp,$sp,-12
sw $ra,($sp)
sw $s0,4($sp)
sw $s1,8($sp)

la $s0,highscore_str
la $s1,jugadores

#Calculo donde leer en memoria.
#posicion=jugadores+posicion_ranking*4
li $t0,4
multu $a0,$t0
mflo $t0
addu $s1,$s1,$t0 #Empiezo en mi ranking

#Calculo donde escribir los datos leidos.
#Highscore_str+posicion_ranking*10:
li $t0,10 #Ej: 01-ABC-123\n son 10 char por posicion.
multu $a0,$t0
mflo $t0
addu $s0,$s0,$t0 #Empiezo en mi ranking

#Escribo numero de ranking
#Si es el 10 lo escribo de otra forma.
beq $a0,9,escribir_10
#Si es un numero de un digito, guardo un 0 y luego el numero deseado.

#Guardo 0
li $t0,48
sb $t0,($s0)

#Muevo el puntero.
addiu $s0,$s0,1

#Guardo numero ranking
addiu $t0,$a0,49
sb $t0,($s0)

#Muevo el puntero.
addiu $s0,$s0,1

j escribir_nombre

escribir_10:

#Guardo 1
li $t0,49
sb $t0,($s0)

#Muevo el puntero.
addiu $s0,$s0,1

#Guardo 0
li $t0,48
sb $t0,($s0)

#Muevo el puntero.
addiu $s0,$s0,1

#Hasta ahora el txt es: 05(posicion del ranking)

escribir_nombre:

#Escribo "-"
li $t0,45
sb $t0,($s0)

#Muevo el puntero.
addiu $s0,$s0,1

#Loop nombre:
#Aumento el 3 pues quiero leer la primer letra del nombre.
addiu $s1,$s1,3

#Contador auxiliar.
li $t0,0
escribir_nombre_loop:
#Mientas no mueva las 3 letras del nombre sigo.
beq $t0,3,escribir_puntaje

#Cargo la letra 
lb $t2,($s1) 

#Si el caracter del nombre es nulo entonces pongo un punto.
bnez $t2,escribir_nombre_seguir
#Char "."
li $t2,46
escribir_nombre_seguir:
#Si no es vacio pego la letra en el lugar deseado.
sb $t2,($s0)
 
#Actualizo el contador y el puntero.
addiu $s0,$s0,1
addiu $t0,$t0,1
addiu $s1,$s1,-1

j escribir_nombre_loop

escribir_puntaje:

#Escribo "-"

li $t0,45
sb $t0,($s0)

#Muevo el puntero.
addiu $s0,$s0,1

#Cargo el puntaje y lo paso a string
lb $a0,($s1)
jal parse_string

#Con el puntaje en dos digitos en ascii los guardo.
sb $v1,($s0)
#Muevo el puntero.
addiu $s0,$s0,1

sb $v0,($s0)
#Muevo el puntero.
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



#*********CONVERSOR NUMERO A STRING**************#

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






