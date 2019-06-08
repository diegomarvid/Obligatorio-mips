.data
.align 2
file_name: .asciiz "D:\highscore.txt"
file_data: .space 256
error_str: .asciiz "error lectura"
file_str: .asciiz "Effa se la come"

.text

## CARGAR ARCHIVO ##

li $v0,13
la $a0,file_name
li $a1,0 # 0 -> leer
li $a2,0 # 0 -> ignorar modo
syscall

move $t0,$v0 #Devuelve el archivo abierto


## LEER ARCHIVO ##

li $v0,14
move $a0,$t0
la $a1,file_data
li $a2,15 #Cantidad caracteres para leer max
syscall

move $t1,$v0 #Devuelve cantidad caracteres leidos
             # 0 -> Nada, -1 -> error
             
bltz $t1,error             
             
## CERRAR ARCHIVO ##

li $v0,16
move $a0,$t0
syscall


## MANEJO DE ARCHIVO ##

la $t0,file_data

loop:
beqz $t1,loop_fin

lb $t2,($t0)

li $v0,11
move $a0,$t2
syscall

addiu $t0,$t0,1
addiu $t1,$t1,-1

j loop

loop_fin:

li $v0,10
syscall



error:

li $v0,4
la $a0,error_str
syscall

li $v0,10
syscall
                                                 
                                                  
                                                                                                    
