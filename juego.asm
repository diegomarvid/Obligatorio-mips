.globl juego

.data

modos_str: .asciiz "Seleccione su modo de juego: \n1- Normal \n2-Rewind \n3-Trickster \n"
pre_secuencia_str: .asciiz "La secuencia es: \n"
enter: .asciiz "\n"

secuencia: .space 200

.text

#-------------------------------------------------------------
juego:

addiu $sp,$sp,-12
sw $ra,($sp)
sw $s1,4($sp)
sw $s2,8($sp)

#Guardo turno en s1
li $s1,1

modos:
#Mensaje Modos
li $v0,51
la $a0,modos_str
syscall

#en a1 guardo el status, 0 = OK
beq $a1,2,juego_fin
bnez $a1,modos

#Evaluo que el modo este entre 1 y 3
bgt $a0,3,modos
blt $a0,1,modos

#En s2 esta el modo de juego
move $s2,$a0

game_loop:

#ACTUALIZO SECUENCIA
move $a0,$s1
jal extender_secuencia

#print provisorio pre-secuencia
li $v0,4
la $a0,pre_secuencia_str
syscall

#IMPRIMO SECUENCIA
move $a0,$s1
la $a1,secuencia
jal imprimir_secuencia

#print enter
li $v0,4
la $a0,enter
syscall

#INGRESO Y VERIFICO SECUENCIA
move $a0,$s1
move $a1,$s2
jal usuario_juega

#DECIDO SI SEGUIR JUGANDO
beqz $v0,decision_juego

#ACTUALIZO TURNO
addiu $s1,$s1,1

j game_loop


decision_juego:

jal volver_jugar

bnez $v0,juego


juego_fin:

lw $ra,($sp)
lw $s1,4($sp)
lw $s2,8($sp)
addiu $sp,$sp,12
jr $ra

#-------------------------------------------------------------

#Le llega largo de la secuencia random en $a0
extender_secuencia:

move $t1,$a0 #Numero de turno en t1
la $t0, secuencia

#Genero RANDOM en $a0
li $a1,4
li $v0,42
syscall


#Actualizo posicion de memoria para guardar
addu $t0,$t0,$t1

#Resto uno a $t0 porque el turno empieza en 1 pero se guarda desde la posicion 0
sb $a0,-1($t0)

jr $ra

#---------------------------------------------------------------------

usuario_juega:

addiu $sp,$sp,-4
sw $ra,($sp)

#a1 es el modo

beq $a1,1,juega_normal
beq $a1,2,juega_rewind
beq $a1,3,juega_trickster

#$a0 es el turno

juega_normal:

 jal modo_normal

 j usuario_juega_final
 
juega_rewind:

 jal modo_rewind

 j usuario_juega_final

juega_trickster:

 #jal modo_trickster

 j usuario_juega_final

usuario_juega_final:

lw $ra,($sp)
addiu $sp,$sp,4

jr $ra

#--------------------------------------------------------------------

modo_normal:

 addiu $sp,$sp,-16
 sw $ra,($sp)
 sw $s0,4($sp)
 sw $s1,8($sp)
 sw $s2,12($sp)
 

 li $s0,0     #Sub turnos del jugador -> numero de jugada
 move $s1,$a0 #Turno en el que estoy
 la $s2,secuencia


 normal_loop:

  beq $s0,$s1,modo_normal_fin

  #Juega turno
  li $v0,5
  syscall
  
  move $t3,$v0 #En v0 queda el valor de la jugada
  
  lb $t4,($s2) #Valor de la secuencia real

  #Me fijo si la jugada es buena 
  beq $t3,$t4,seguir_normal 

   #-----ERROR-XXXX-----------#

   
   #Sonido erroneo
   li $v0,33
   li $a0,58
   li $a1,500
   li $a2,56
   li $a3,100
   syscall
   
   li $v0,0
   j modo_normal_fin
 
  
   #------BIEN---------------#
 seguir_normal:
 
  #Sonido
  move $a0,$t3
  jal sonido_secuencia

  addiu $s0,$s0,1
  addiu $s2,$s2,1
  li $v0,1 #v0 = 1, le emboque
  j normal_loop

 modo_normal_fin:
   
  lw $ra,($sp)
  lw $s0,4($sp)
  lw $s1,8($sp)
  lw $s2,12($sp)
  addiu $sp,$sp,16

  jr $ra

#---------------------------------------------------------------------

modo_rewind:

 addiu $sp,$sp,-16
 sw $ra,($sp)
 sw $s0,4($sp)
 sw $s1,8($sp)
 sw $s2,12($sp)

 li $s0,0     #Sub turnos del jugador - cada jugada
 move $s1,$a0 #Turno en el que estoy
 
 #Arranco desde el final
 addiu $t3,$s1,-1
 la $s2,secuencia($t3)
  

 rewind_loop:

  beq $s0,$s1,modo_rewind_fin

  #Juega turno
  li $v0,5
  syscall

  move $t3,$v0 #En v0 queda el valor de la jugada
  
  lb $t4,($s2) #Valor de la secuencia real

  #Me fijo si la jugada es buena 
  beq $t3,$t4,seguir_rewind 
  
   #-----ERROR-XXXX-----------#

   
   #Sonido erroneo
   li $v0,33
   li $a0,58
   li $a1,500
   li $a2,56
   li $a3,100
   syscall

   #Si no le emboco termino
   li $v0,0
   j modo_rewind_fin
   
   #------BIEN---------------#

 seguir_rewind:
 
  #Sonido
  move $a0,$t3
  jal sonido_secuencia

  addiu $s0,$s0,1
  addiu $s2,$s2,-1
  li $v0,1 #v0 = 1, le emboque
  j rewind_loop

 modo_rewind_fin:
 
 lw $ra,($sp)
 lw $s0,4($sp)
 lw $s1,8($sp)
 lw $s2,12($sp)
 addiu $sp,$sp,16

 jr $ra

#----------------------------------------------------------------
