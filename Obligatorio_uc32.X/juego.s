.globl juego

.data


.text

#   *******LOOP JUEGO********#  
    
#  $a0 -> Modo    
    
juego:

addiu $sp,$sp,-12
sw $ra,($sp)
sw $s1,4($sp)
sw $s2,8($sp)

#  Guardo turno en s1.
li $s1,1
#  Guardo modo en s2.   
move $s2,$a0
 
# Apago un tiempo antes de mostrar secuencia.   
sw $0,PORTD    
li $a0,65000    
jal sleep    
    
game_loop:

#   VERIFICO GANADOR
    
beq $s1,99,juego_gane    

#   ACTUALIZO SECUENCIA
move $a0,$s1
jal extender_secuencia

#   IMPRIMO SECUENCIA
move $a0,$s1
jal imprimir_secuencia

#   INGRESO Y VERIFICO SECUENCIA
move $a0,$s1
move $a1,$s2
jal usuario_juega

#   DECIDO SI SEGUIR JUGANDO
#  Si pierdo $v0 es cero y salgo del loop.
beqz $v0,juego_perder

#   ACTUALIZO TURNO
addiu $s1,$s1,1
   
j game_loop
    
    
juego_perder:
    
jal animacion_perder     
    
j juego_fin
    
juego_gane:
    
jal animacion_ganar    

juego_fin:
lw $ra,($sp)
lw $s1,4($sp)
lw $s2,8($sp)
addiu $sp,$sp,12
jr $ra

#   ******************************EXTENDER SECUENCIA*******************************#  

#   En $a0 recibe el turno para agregar un valor al final de la secuencia.
extender_secuencia:

addiu $sp,$sp,-12
sw $ra,($sp)
sw $s0,4($sp)
sw $s1,8($sp)     
    
move $s1,$a0
la $s0, secuencia

#   Genero RANDOM en $v0
jal random

#   El ultimo lugar del array es: direccion_array+turno-1.

#   Direccion de array + turno
addu $s0,$s0,$s1
#   direccion_array+turno-1
sb $v0,-1($s0)
    
lw $ra,($sp) 
lw $s0,4($sp)
lw $s1,8($sp)    
addiu $sp,$sp,12
    
jr $ra

    
#   *****************SWITCH MODOS AL JUGAR*****************#  
#   En $a0 recibe el turno.
#   En $a1 recibe el modo.
usuario_juega:

addiu $sp,$sp,-4
sw $ra,($sp)

#   Switch para evaluar la jugada del usuario.
beq $a1,1,juega_normal
beq $a1,2,juega_rewind


juega_normal:

 jal modo_normal

 j usuario_juega_final
 
juega_rewind:

 jal modo_rewind

 j usuario_juega_final


usuario_juega_final:

lw $ra,($sp)
addiu $sp,$sp,4

jr $ra



#   *********CONTROL DE JUGADA EN MODO NORMAL**********#  
    
#   En $a0 recibe el turno actual.
#   Devuelve en $v0 = 1 si realiza la secuencia de forma correcta y $v0 = 0 de lo contrario.
modo_normal:

 addiu $sp,$sp,-20
 sw $ra,($sp)
 sw $s0,4($sp)
 sw $s1,8($sp)
 sw $s2,12($sp)
 sw $s3,16($sp)
 
#   Subturnos del jugador -> numero de jugada.
 li $s0,0
 #   Turno actual en el que esta el jugador.
 move $s1,$a0 
 #   Inicio del array donde esta la secuencia a seguir.
 la $s2,secuencia


 normal_loop:

  #   Si ya realice toda la secuencia de forma correcta termine.
  beq $s0,$s1,modo_normal_fin

  #  Obtiene la jugada del usuario.
  jal get_play
  move $s3,$v0 #  En v0 queda el valor de la jugada
  
  #  Si el usuario no jugo (pierde por tiempo), se deja de pedir jugadas.
  beq $s3,-1,normal_error

  #  Ilumino la jugada realizada.
  move $a0,$s3
  jal display_light
  
  #  Evaluo si la juaga realizada es la correcta.
  lb $t4,($s2) #  Valor de la secuencia real.
  beq $s3,$t4,seguir_normal 

   #  ------------ERROR------------#  
   normal_error:   
    
   #  Carga en $v0 el valor de errarle.
   li $v0,0
   
   j modo_normal_fin
 
  
   #  -----------BIEN---------------#  
 seguir_normal:

 #  Aumenta el subturno.
  addiu $s0,$s0,1
 #  Aumenta el puntero de la secuencia.
  addiu $s2,$s2,1
 #  Cargamos v0 = 1 pues el usuario le emboco.
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


# ***********CONTROL DE JUGADA EN MODO REWIND************# 
# En $a0 recibe el turno actual.
# Devuelve en $v0=1 si realiza la secuencia de forma correcta y $v0=0 de lo contrario.

modo_rewind:

 addiu $sp,$sp,-20
 sw $ra,($sp)
 sw $s0,4($sp)
 sw $s1,8($sp)
 sw $s2,12($sp)
 sw $s3,16($sp)

 # Subturnos del jugador-> numero de jugada.
 li $s0,0
 # Turno actual en el que esta el jugador.
 move $s1,$a0 
 
 # Arranco a leer la secuencia desde el final.
 addiu $t3,$s1,-1
 la $s2,secuencia($t3)
  

 rewind_loop:
 
  # Si ya realice toda la secuencia de forma correcta termine.
  beq $s0,$s1,modo_rewind_fin

  # Obtiene la jugada del usuario.
  jal get_play
  move $s3,$v0 # En v0 queda el valor de la jugada
  
  # Si el usuario no jugo (pierde por tiempo), se deja de pedir jugadas.
  beq $s3,-1,rewind_error
  
  
  # Ilumino la jugada realizada.
  move $a0,$s3
  jal display_light
  
  # Evaluo si la juaga realizada es la correcta.
  lb $t4,($s2) # Valor de la secuencia real
  beq $s3,$t4,seguir_rewind 
  
   # -----------ERROR------------# 

   rewind_error:
    
   # Carga en $v0 el valor de errarle.
   li $v0,0
   j modo_rewind_fin
   
   # -----------BIEN---------------# 

 seguir_rewind:

  # Aumenta el subturno.
  addiu $s0,$s0,1
  # Disminuyo el puntero de la secuencia.
  addiu $s2,$s2,-1
  # Cargamos v0 = 1 pues el usuario le emboco.
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


