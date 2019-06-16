.eqv green  0x00FF00
.eqv red    0xFF0000
.eqv yellow 0xFFFF00
.eqv blue   0x0000FF

.eqv green_light  0xAAFE90
.eqv red_light    0xF08080
.eqv yellow_light 0xFFFF99
.eqv blue_light   0x1E90FF


#Funciones
.globl refresh_coordinates
.globl refresh_display
.globl display_light
.globl imprimir_secuencia
.globl volver_jugar

#Data


.data

#Unit width in pixels: 32
#Unit height in pixels: 32
#Display width in Pixels: 256
#Display Height in pixels: 256
#Base address: static data

#display: .space 256


.text



#************MAPEO JUGADA A COLOR******#


#En $a0 recibo el modo de juego


refresh_coordinates:

beq $a0,3,refresh_trickster

li $t0,0
sw $t0,green_cord

li $t0,1
sw $t0,red_cord

li $t0,2
sw $t0,blue_cord

li $t0,3
sw $t0,yellow_cord

j refresh_coordinates_fin

refresh_trickster:

#-Esquina para verde-#

#Genero RANDOM en $a0
li $a1,4
li $v0,42
syscall

sw $a0,green_cord

move $t0,$a0

#-Esquina para rojo-#

refresh_trickster_red:

li $a1,4
li $v0,42
syscall

beq $a0,$t0,refresh_trickster_red


sw $a0,red_cord

move $t1,$a0

#-Esquina para azul-#

refresh_trickster_blue:

li $a1,4
li $v0,42
syscall

beq $a0,$t0,refresh_trickster_blue
beq $a0,$t1,refresh_trickster_blue

sw $a0,blue_cord

move $t2,$a0

#-Esquina para amarillo-#

refresh_trickster_yellow:

li $a1,4
li $v0,42
syscall

beq $a0,$t0,refresh_trickster_yellow
beq $a0,$t1,refresh_trickster_yellow
beq $a0,$t2,refresh_trickster_yellow


sw $a0,yellow_cord

move $t3,$a0

refresh_coordinates_fin:
jr $ra

#*****************CUADRADO**************#

# $a0 -> esquina
# $a1 -> Color

cuadrado:

li $t0,3 #Contador filas
li $t1,4 #Contador columnas

#Saber cuantas columnas saltear
li $t5,16
multu $a0,$t5
mflo $t5


la $t2,display #Direccion para pintar filas

#Intento arreglar desfasaje de bitmap con el align
addiu $t2,$t2,0

bgt $a0,1,cuadrado_esquinas_abajo

addu $t2,$t2,$t5


j cuadrado_columnas_loop

cuadrado_esquinas_abajo:

li $t4,176

subu $t5,$t4,$t5
addu $t2,$t2,$t5

#Pinto columnas
cuadrado_columnas_loop:

beqz $t1,cuadrado_filas

sw $a1,($t2)

addiu $t2,$t2,4

addiu $t1,$t1,-1

j cuadrado_columnas_loop

cuadrado_filas:

beqz $t0,cuadrado_fin

#Cambio de fila
addiu $t2,$t2,16

addiu $t0,$t0,-1

#Reinicio contador columnas
li $t1,4

j cuadrado_columnas_loop


cuadrado_fin:
jr $ra


#**************DISPLAY LIGHT**********#

# $a0 -> Jugada

display_light:

addiu $sp,$sp,-8
sw $ra,($sp)

beq $a0,0,display_light_green

beq $a0,1,display_light_red

beq $a0,2,display_light_blue

beq $a0,3,display_light_yellow


display_light_green:

lw $a0,green_cord
li $a1,green_light
jal cuadrado

li $a0,600
li $v0,32
syscall

lw $a0,green_cord
li $a1,green
jal cuadrado

j display_light_fin

display_light_red:

lw $a0,red_cord
li $a1,red_light
jal cuadrado

li $a0,600
li $v0,32
syscall


lw $a0,red_cord
li $a1,red
jal cuadrado

j display_light_fin

display_light_blue:

lw $a0,blue_cord
li $a1,blue_light
jal cuadrado

li $a0,600
li $v0,32
syscall

lw $a0,blue_cord
li $a1,blue
jal cuadrado


j display_light_fin

display_light_yellow:

lw $a0,yellow_cord
li $a1,yellow_light
jal cuadrado

li $a0,600
li $v0,32
syscall

lw $a0,yellow_cord
li $a1,yellow
jal cuadrado

j display_light_fin


display_light_fin:

#jal display_init

lw $ra,($sp)
addiu $sp,$sp,8
jr $ra

#**********Refresh display***********#

refresh_display:

addiu $sp,$sp,-4
sw $ra,($sp)


lw $a0,green_cord
li $a1,green
jal cuadrado


lw $a0,red_cord
li $a1,red
jal cuadrado

lw $a0,blue_cord
li $a1,blue
jal cuadrado

lw $a0,yellow_cord
li $a1,yellow
jal cuadrado

refresh_display_fin:


lw $ra,($sp)
addiu $sp,$sp,4
jr $ra

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



 #Hace el sonido de la jugada realizada.
  move $a0,$s3
  jal sonido_secuencia
  
  li $a0,100
  li $v0,32
  syscall
  
  #Ilumino la jugada realizada.
  move $a0,$s3
  jal display_light


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







