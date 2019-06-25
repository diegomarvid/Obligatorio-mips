.globl leer_archivo

.text


leer_archivo:

#Consigo file descriptor

li $v0,13
la $a0,file_name
li $a1,9 # 0 -> leer
li $a2,0 # 0 -> ignorar modo
syscall

move $v0,$t7

li $v0,16
move $a0,$t7
syscall

## CARGAR ARCHIVO ##

li $v0,13
la $a0,file_name
li $a1,1 # 0 -> leer
li $a2,0 # 0 -> ignorar modo
syscall

move $t7,$v0 #Devuelve el archivo abierto

bltz $t7,leer_archivo_error

## LEER ARCHIVO ##

li $v0,14
move $a0,$t7
la $a1,file_data
li $a2,100 #Cantidad caracteres para leer max
syscall

move $t1,$v0 #Devuelve cantidad caracteres leidos
             # 0 -> Nada, -1 -> error

## MANEJO DE ARCHIVO ##

la $t0,file_data #Highscore_str
li $t2,0 #Numero de ranking -1
la $t4,jugadores

leer_archivo_loop:

beq $t2,10,leer_archivo_loop_fin

#Empiezo a cargar de la ultima letra
addiu $t0,$t0,3
addiu $t4,$t4,3

#Loop nombre

li $t3,0

leer_archivo_nombre_loop:

beq $t3,3,leer_archivo_puntaje

lb $t5,($t0)
sb $t5,($t4)

addiu $t4,$t4,-1
addiu $t0,$t0,1
addiu $t3,$t3,1

j leer_archivo_nombre_loop

leer_archivo_puntaje:

#Muevo puntero hacia el puntaje
addiu $t0,$t0,1

#Paso a int:
#Digito grande
lb $t5,($t0)

#Si es vacio, es por que el archivo es nuevo y no posee puntajes.
beqz $t5,vacio_decenas
addiu $t5,$t5,-48
vacio_decenas:

li $t3,10
multu $t5,$t3
mflo $t3
#Digito chico
addiu $t0,$t0,1
lb $t5,($t0)

#Si es vacio, es por que el archivo es nuevo y no posee puntajes.
beqz $t5,vacio_unidades
addiu $t5,$t5,-48
vacio_unidades:

#Sumo digitos
addu $t3,$t3,$t5

#Guardo en memoria
sb $t3,($t4)

#Dejo puntero en el ranking del proximo
addiu $t0,$t0,2
addiu $t4,$t4,4

addiu $t2,$t2,1

j leer_archivo_loop

leer_archivo_loop_fin:

## CERRAR ARCHIVO ##

li $v0,16
move $a0,$t7
syscall

li $v1,1

j leer_archivo_fin

leer_archivo_error:

li $v1,0

li $v0,16
move $a0,$t7
syscall

leer_archivo_fin:


move $v0,$v1

jr $ra
