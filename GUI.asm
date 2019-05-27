.eqv green  0x00FF00
.eqv red    0xFF0000
.eqv yellow 0xFFFF00
.eqv blue   0x0000FF

.data

#Unit width in pixels: 32
#Unit height in pixels: 32
#Display width in Pixels: 256
#Display Height in pixels: 256
#Base address: static data

display: .space 256

.text

li $a0,0
li $a1,green
jal cuadrado

li $a0,1
li $a1,red
jal cuadrado

li $a0,2
li $a1,yellow
jal cuadrado

li $a0,3
li $a1,blue
jal cuadrado

li $v0,10
syscall

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

bgt $a0,1,cuadrado_esquinas_abajo

addu $t2,$t2,$t5


j cuadrado_columnas_loop

cuadrado_esquinas_abajo:

addiu $t5,$t5,96 #Salto de filas hasta la mitad de abajo
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
