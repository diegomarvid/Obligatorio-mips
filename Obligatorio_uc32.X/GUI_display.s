.globl extender_secuencia
.globl display_light
.globl imprimir_secuencia    
.globl secuencia    
    
.data
    
secuencia: .space 99    
    
    
.text
  
# ******************************EXTENDER SECUENCIA*******************************#

# En $a0 recibe el turno para agregar un valor al final de la secuencia.
extender_secuencia:

move $t1,$a0
    
la $t0, secuencia

# Genero RANDOM en $a0
li $a0,1

# El ultimo lugar del array es: direccion_array+turno-1.

# Direccion de array + turno
addu $t0,$t0,$t1
# direccion_array+turno-1
sb $a0,-1($t0)

jr $ra
    
# *****************************IMPRIMIR SECUENCIA********************************#
    
imprimir_secuencia:

addiu $sp,$sp,-16
sw $ra,($sp)
sw $s0,4($sp)
sw $s2,8($sp)
sw $s3,12($sp)

la $s0, secuencia
move $s2, $a0 #Numero de turno, se usa para saber cuantas veces imprimir

loop:

beqz $s2, imprimir_fin

lb $s3,($s0) #Valor de la secuencia para mostrar

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


# ************ DISPLAY LIGHT ******************#

# $a0 -> Jugada realizada   
    
display_light:
    
li $t0,0 # TODO APAGADOS
    
beq $a0,0,display_light_green
beq $a0,1,display_light_red
beq $a0,2,display_light_blue
beq $a0,3,display_light_yellow    
    
display_light_green:
    
li $t0,1 # RD0
      
j display_light_on    
    
display_light_red: 
    
li $t0,2 # RD1   
    
j display_light_on      
    
display_light_blue:     
 
li $t0,4 # RD2   

j display_light_on    
    
display_light_yellow:   
    
li $t0,8 # RD3  
    
j display_light_on      
    
    
    
    
display_light_on:  
    
# Prendo LED    
sw $t0,PORTD
    
# Sleep
li $t0,0
    
display_light_loop:    
beq $t0,45000,display_light_fin   
addiu $t0,$t0,1
j display_light_loop    
     
    
display_light_fin:   
    
# Apagar
li $t0,0    
sw $t0,PORTD
    
    
loop1:    
beq $t0,45000,fin   
addiu $t0,$t0,1
j loop1      
fin:   
    
jr $ra    
