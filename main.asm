.globl main
.globl display
.globl bienvenido_str

.data


.align 2
display: .space 256
.align 2
bienvenido_str: .asciiz "Bienvenido a Simon \n"

.text

#-------MAIN--------#

main:

#Mensaje de bienvenida
li $v0,55
la $a0,bienvenido_str
li $a1,1
syscall
 

jal refresh_display

jal juego 


li $v0,10
syscall








