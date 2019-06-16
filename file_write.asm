
#Funciones
.globl cargar_archivo


.text

##********CARGAR ARCHIVO************** ##


cargar_archivo:


# ABRO ARCHIVO

li $v0,13
la $a0,file_name
li $a1,1 # 1 -> escribir
li $a2,0 # 0 -> ignorar modo
syscall

move $t0,$v0 #Devuelve el archivo abierto


## ESCRIBO ARCHIVO ##

li $v0,15
move $a0,$t0
la $a1,highscore_str #Posee los rankings en formato string para el usuario
li $a2,100 
syscall

move $t1,$v0 #Devuelve cantidad caracteres escritos
             # 0 -> Nada, -1 -> error

# Evaluo si no se pudo escribir                          
bgez $t1,cargar_archivo_fin            

li $v0,4
la $a0,error_str
syscall                                                  
             
cargar_archivo_fin:
                    
## CERRAR ARCHIVO ##

li $v0,16
move $a0,$t0
syscall

jr $ra


