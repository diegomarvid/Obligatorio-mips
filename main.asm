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

#Words:
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
.globl ganador_title_str
.globl higscore_title



.data

#Spaces:

#GUI_display
display: .space 256
#Juego
secuencia: .space 200
#Highscore
jugadores: .space 40
highscore_str: .space 101
jugador_nombre: .space 4
#File_write_read
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
bienvenido_str: .asciiz "Bienvenido a Simon \n"
#Juego
modos_str: .asciiz "Seleccione su modo de juego: \n1- Normal \n2-Rewind \n3-Trickster \n"
ganador_str: .asciiz "Felicitaciones, ganaste!!! \n"
ganador_title_str: .asciiz " "
higscore_title: .asciiz "El highscore es:\n"
#Highscore
ingreso_nombre_str: .asciiz "Ingrese nombre de jugador: " 
#Imprimir
decisionstr: .asciiz "Desea volver a jugar? \n"
#File
error_str: .asciiz "error"
file_name: .asciiz "D:\highscore.txt"

.text

#-------MAIN--------#

main:

# Mensaje de bienvenida
li $v0,55
la $a0,bienvenido_str
li $a1,1
syscall

#Persistencia.
jal leer_archivo 
#Llamo al juego.
jal juego 

li $v0,10
syscall








