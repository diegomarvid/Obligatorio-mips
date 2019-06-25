
#Funciones
.globl juego

.data


.text

#*******LOOP JUEGO********#
juego:

addiu $sp,$sp,-12
sw $ra,($sp)
sw $s1,4($sp)
sw $s2,8($sp)

#Inicializo las condiciones del juego.
jal refresh_display

#Guardo turno en s1
li $s1,1

modos:

#Mensaje Modos
li $v0,51
la $a0,modos_str
syscall

#en a1 guardo el status, 0 = OK

beq $a1,-2,juego_fin
blt $a1,0, modos

#Evaluo que el modo este entre 1 y 3
bgt $a0,3,modos
blt $a0,1,modos

#En s2 esta el modo de juego
move $s2,$a0

#Siempre que incio un juego nuevo, actualizo las coordenadas de los colores y la pantalla
#Excepto en trickster, no importa como comienzan las coordenadas del color.
beq $a0,3,game_loop

jal refresh_coordinates
jal refresh_display

game_loop:

#VERIFICO SI GANO
beq $s1,99,juego_gane

#ACTUALIZO SECUENCIA
move $a0,$s1
jal extender_secuencia

#IMPRIMO SECUENCIA
move $a0,$s1
la $a1,secuencia
jal imprimir_secuencia

#INGRESO Y VERIFICO SECUENCIA
move $a0,$s1
move $a1,$s2
jal usuario_juega

#DECIDO SI SEGUIR JUGANDO
#Si pierdo $v0 es cero y salgo del loop.
beqz $v0,decision_juego

#ACTUALIZO TURNO
addiu $s1,$s1,1

j game_loop

#SI PERDI LA PARTIDA.
decision_juego:
#Turno menos 1 es el puntaje.
move $a0,$s1
addiu $a0,$a0,-1 

#Agregar highscore, pide nombre y evalua si esta en el top 10.
jal actualizar_highscore

#Pregunta si se desea jugar nuevamente.
jal volver_jugar
beqz $v0,juego #0 -> seguir jugando, 1 -> terminar

j juego_fin

#SI GANE LA PARTIDA.
juego_gane:

#Mensaje Gane
li $v0,59
la $a0,ganador_str
syscall
#Imprimir mensaje

juego_fin:
lw $ra,($sp)
lw $s1,4($sp)
lw $s2,8($sp)
addiu $sp,$sp,12
jr $ra

#******************************EXTENDER SECUENCIA*******************************#

#En $a0 recibe el turno para agregar un valor al final de la secuencia.
extender_secuencia:

move $t1,$a0
la $t0, secuencia

#Genero RANDOM en $a0
li $a1,4
li $v0,42
syscall

#El ultimo lugar del array es: direccion_array+turno-1.

#Direccion de array + turno
addu $t0,$t0,$t1
#direccion_array+turno-1
sb $a0,-1($t0)

jr $ra

#*****************SWITCH MODOS AL JUGAR*****************#
#En $a0 recibe el turno.
#En $a1 recibe el modo.
usuario_juega:

addiu $sp,$sp,-4
sw $ra,($sp)

#Switch para evaluar la jugada del usuario.
beq $a1,1,juega_normal
beq $a1,2,juega_rewind
beq $a1,3,juega_trickster

juega_normal:

 jal modo_normal

 j usuario_juega_final
 
juega_rewind:

 jal modo_rewind

 j usuario_juega_final

juega_trickster:

 jal modo_trickster

 j usuario_juega_final

usuario_juega_final:

lw $ra,($sp)
addiu $sp,$sp,4

jr $ra



#*********CONTROL DE JUGADA EN MODO NORMAL**********#
#En $a0 recibe el turno actual.
#Devuelve en $v0=1 si realiza la secuencia de forma correcta y $v0=0 de lo contrario.
modo_normal:

 addiu $sp,$sp,-20
 sw $ra,($sp)
 sw $s0,4($sp)
 sw $s1,8($sp)
 sw $s2,12($sp)
 sw $s3,16($sp)
 
#Subturnos del jugador-> numero de jugada.
 li $s0,0
 #Turno actual en el que esta el jugador.
 move $s1,$a0 
 #Inicio del array donde esta la secuencia a seguir.
 la $s2,secuencia


 normal_loop:

  #Si ya realice toda la secuencia de forma correcta termine.
  beq $s0,$s1,modo_normal_fin

  #Obtiene la jugada del usuario.
  jal get_play
  move $s3,$v0 #En v0 queda el valor de la jugada
  
  #Si el usuario no jugo (pierde por tiempo), se deja de pedir jugadas.
  beq $s3,-1,normal_error
  
  #Hace el sonido de la jugada realizada.
  move $a0,$s3
  jal sonido_secuencia
  
  li $a0,100
  li $v0,32
  syscall
  
  #Ilumino la jugada realizada.
  move $a0,$s3
  jal display_light
  
  #Evaluo si la juaga realizada es la correcta.
  lb $t4,($s2) #Valor de la secuencia real.
  beq $s3,$t4,seguir_normal 

   #------------ERROR------------#
   normal_error:   
   #Sonido de jugada erronea.
   li $v0,33
   li $a0,58
   li $a1,500
   li $a2,56
   li $a3,100
   syscall
   
   #Carga en $v0 el valor de errarle.
   li $v0,0
   j modo_normal_fin
 
  
   #-----------BIEN---------------#
 seguir_normal:

 #Aumenta el subturno.
  addiu $s0,$s0,1
 #Aumenta el puntero de la secuencia.
  addiu $s2,$s2,1
 #Cargamos v0 = 1 pues el usuario le emboco.
  li $v0,1
  
  j normal_loop

 modo_normal_fin:
   
  lw $ra,($sp)
  lw $s0,4($sp)
  lw $s1,8($sp)
  lw $s2,12($sp)
  lw $s3,16($sp)
  addiu $sp,$sp,20

  jr $ra





#***********CONTROL DE JUGADA EN MODO REWIND************#
#En $a0 recibe el turno actual.
#Devuelve en $v0=1 si realiza la secuencia de forma correcta y $v0=0 de lo contrario.

modo_rewind:

 addiu $sp,$sp,-20
 sw $ra,($sp)
 sw $s0,4($sp)
 sw $s1,8($sp)
 sw $s2,12($sp)
 sw $s3,16($sp)

 #Subturnos del jugador-> numero de jugada.
 li $s0,0
 #Turno actual en el que esta el jugador.
 move $s1,$a0 
 
 #Arranco a leer la secuencia desde el final.
 addiu $t3,$s1,-1
 la $s2,secuencia($t3)
  

 rewind_loop:
 
  #Si ya realice toda la secuencia de forma correcta termine.
  beq $s0,$s1,modo_rewind_fin

  #Obtiene la jugada del usuario.
  jal get_play
  move $s3,$v0 #En v0 queda el valor de la jugada
  
  #Si el usuario no jugo (pierde por tiempo), se deja de pedir jugadas.
  beq $s3,-1,rewind_error
  
  #Hace el sonido de la jugada realizada.
  move $a0,$s3
  jal sonido_secuencia
  
  li $a0,100
  li $v0,32
  syscall
  
  #Ilumino la jugada realizada.
  move $a0,$s3
  jal display_light
  
  #Evaluo si la juaga realizada es la correcta.
  lb $t4,($s2) #Valor de la secuencia real
  beq $s3,$t4,seguir_rewind 
  
   #-----------ERROR------------#

   rewind_error:
   #Sonido de jugada erronea.
   li $v0,33
   li $a0,58
   li $a1,500
   li $a2,56
   li $a3,100
   syscall

   #Carga en $v0 el valor de errarle.
   li $v0,0
   j modo_rewind_fin
   
   #-----------BIEN---------------#

 seguir_rewind:

  #Aumenta el subturno.
  addiu $s0,$s0,1
  #Disminuyo el puntero de la secuencia.
  addiu $s2,$s2,-1
  #Cargamos v0 = 1 pues el usuario le emboco.
  li $v0,1
  
  j rewind_loop

 modo_rewind_fin:
 
 lw $ra,($sp)
 lw $s0,4($sp)
 lw $s1,8($sp)
 lw $s2,12($sp)
 lw $s3,16($sp)
 addiu $sp,$sp,20

 jr $ra

#***********CONTROL DE JUGADA EN MODO TRICKSTER************#
#En $a0 recibe el turno actual.
#Devuelve en $v0=1 si realiza la secuencia de forma correcta y $v0=0 de lo contrario.
modo_trickster:

 addiu $sp,$sp,-20
 sw $ra,($sp)
 sw $s0,4($sp)
 sw $s1,8($sp)
 sw $s2,12($sp)
 sw $s3,16($sp)
 
 #Subturnos del jugador-> numero de jugada.
 li $s0,0
 #Turno actual en el que esta el jugador.
 move $s1,$a0 
 #Inicio del array donde esta la secuencia a seguir.
 la $s2,secuencia
 
 #Re organizo colores, despues de mostrar la secuencia.
 li $a0,3
 jal refresh_coordinates
 jal refresh_display
 

 
 trickster_loop:
  #Si ya realice toda la secuencia de forma correcta termine.
  beq $s0,$s1,modo_trickster_fin

  #Obtiene la jugada del usuario.
  jal get_play
  move $s3,$v0 #En v0 queda el valor de la jugada.
  
  #Si el usuario no jugo (pierde por tiempo), se deja de pedir jugadas.
  beq $s3,-1,trickster_error
  
 #Hace el sonido de la jugada realizada.
  move $a0,$s3
  jal sonido_secuencia
  
  li $a0,100
  li $v0,32
  syscall
  
  #Ilumino la jugada realizada.
  move $a0,$s3
  jal display_light
  
  #Evaluo si la juaga realizada es la correcta.
  lb $t4,($s2) #Valor de la secuencia real.
  beq $s3,$t4,seguir_trickster 
  
   #--------ERROR-----------#

   trickster_error:
   #Sonido de jugada erronea.
   li $v0,33
   li $a0,58
   li $a1,500
   li $a2,56
   li $a3,100
   syscall

   #Carga en $v0 el valor de errarle.
   li $v0,0
   j modo_trickster_fin
   
   #-------------BIEN---------------#

 seguir_trickster:
 
  #Aumenta el subturno.
  addiu $s0,$s0,1
  #Aumento el puntero de la secuencia.
  addiu $s2,$s2,1
  #Cargamos v0 = 1 pues el usuario le emboco.
  li $v0,1
  j trickster_loop

 modo_trickster_fin:
 
 lw $ra,($sp)
 lw $s0,4($sp)
 lw $s1,8($sp)
 lw $s2,12($sp)
 lw $s3,16($sp)
 addiu $sp,$sp,20

 jr $ra
