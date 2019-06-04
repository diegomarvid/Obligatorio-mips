.data

file_name: .asciiz "D:\highscore.txt"
file_data: .space 4096
error_str: .asciiz "error lectura"
file_str: .asciiz "Effa se la come"

.text

## CARGAR ARCHIVO ##

li $v0,13
la $a0,file_name
li $a1,1 # 1 -> escribir
li $a2,0 # 0 -> ignorar modo
syscall

move $t0,$v0 #Devuelve el archivo abierto


## ESCRIBIR ARCHIVO ##

li $v0,15
move $a0,$t0
la $a1,file_str
li $a2,15 #Cantidad caracteres para leer max
syscall

move $t1,$v0 #Devuelve cantidad caracteres leidos
             # 0 -> Nada, -1 -> error
             
bltz $t1,error             
             
## CERRAR ARCHIVO ##

li $v0,16
move $a0,$t0
syscall


li $v0,10
syscall


error:

li $v0,4
la $a0,error_str
syscall

li $v0,10
syscall