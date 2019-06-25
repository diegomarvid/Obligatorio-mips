.globl main


#Data:

#Spaces:
.globl display
.globl secuencia
.globl jugadores
.globl highscore_str
.globl jugador_nombre
.globl ingreso_nombre_str
.globl file_data

#Words
.globl green_cord
.globl red_cord
.globl yellow_cord
.globl blue_cord
.globl jugador_actual

#Strings: 
.globl bienvenido_str
.globl modos_str
.globl decisionstr
.globl file_name
.globl error_str
.globl ganador_str





.data

#Spaces:

#GUI_display
.align 2
display: .space 256
#Juego
.align 2
secuencia: .space 200
#Highscore
.align 2
jugadores: .space 40
.align 2
highscore_str: .space 100
.align 2
jugador_nombre: .space 4
#File_write_read
.align 2
file_data: .space 100


#Words

#GUI_display
green_cord: .word 0
red_cord: .word 1
blue_cord: .word 2
yellow_cord: .word 3

#Highscore
jugador_actual: .word 0

#Strings:

#Main
.align 2
bienvenido_str: .asciiz "Bienvenido a Simon \n"
#Juego
.align 2
modos_str: .asciiz "Seleccione su modo de juego: \n1- Normal \n2-Rewind \n3-Trickster \n"
.align 2
ganador_str: .asciiz "Felicitacione, ganaste!!! \n"
#Highscore
.align 2
ingreso_nombre_str: .asciiz "Ingrese nombre de jugador: " 
#Imprimir
.align 2
decisionstr: .asciiz "Desea volver a jugar? \n"
#File_write_read
.align 2
error_str: .asciiz "error lectura"
.align 2
file_name: .asciiz "D:\highscore.txt"

.text

#-------MAIN--------#

main:

#Mensaje de bienvenida
#li $v0,55
#la $a0,bienvenido_str
#li $a1,1
#syscall

#Persistencia.
jal leer_archivo 
#Llamo al juego.
jal juego 

li $v0,10
syscall








