.globl main


.data

bienvenido_str: .asciiz "Bienvenido a Simon \n"

.text

#-------MAIN--------#

main:

#Mensaje de bienvenida
li $v0,4
la $a0,bienvenido_str
syscall


jal juego

li $v0,10
syscall








