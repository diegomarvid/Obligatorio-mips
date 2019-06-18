
.data
    
secuencia: .space 99    
    
    
.text
    
    
    
    
# ******************************EXTENDER SECUENCIA*******************************#

# En $a0 recibe el turno para agregar un valor al final de la secuencia.
extender_secuencia:

move $t1,$a0
    
la $t0, secuencia

# Genero RANDOM en $a0
li $a1,4
li $v0,42
syscall

# El ultimo lugar del array es: direccion_array+turno-1.

# Direccion de array + turno
addu $t0,$t0,$t1
# direccion_array+turno-1
sb $a0,-1($t0)

jr $ra


