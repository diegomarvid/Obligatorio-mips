.globl extender_secuencia
.globl display_light
.globl imprimir_secuencia    
.globl secuencia
.globl random   
.globl animacion_perder
.globl animacion_ganar    
    
.data
    
secuencia: .space 99    
    
    
.text
  
# *****************************IMPRIMIR SECUENCIA********************************#
    
# $a0 -> Numero de turno    
    
imprimir_secuencia:

addiu $sp,$sp,-16
sw $ra,($sp)
sw $s0,4($sp)
sw $s2,8($sp)
sw $s3,12($sp)

la $s0, secuencia
move $s2, $a0 # Numero de turno, se usa para saber cuantas veces imprimir

loop:

beqz $s2, imprimir_fin

lb $s3,($s0) # Valor de la secuencia para mostrar

  # Ilumino la jugada realizada.
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
    
addiu $sp,$sp,-4
sw $ra,($sp)    
    
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
    
li $a0,45000
jal sleep    
     
    
# Apagar
li $t0,0    
sw $t0,PORTD
    
li $a0,45000
jal sleep      
         
lw $ra,($sp)
addiu $sp,$sp,4    
    
jr $ra
    
# ******************RANDOM********************* #
    
    
random:
    
 lw $v0, TMR2
 
 bgt $v0,0xFF00,random_reset
  
 andi $v0,$v0,0b11
 
 random_reset:
 sw $t0, TMR2
 
 andi $v0,$v0,0b11
    
jr $ra    
    
# *********************SLEEP****************** # 
    
# $a0 -> tiempo sleep    
    
sleep:
    
li $t0,0  
    
sleep_loop:
    
beq $t0,$a0,sleep_fin
    
addiu $t0,$t0,1    
    
j sleep_loop     

    
sleep_fin:    
    
jr $ra 
    
    
animacion_perder:

addiu $sp,$sp,-8
sw $ra,($sp)
sw $s1,4($sp)   

    
    
# Defino tiempo de clock
li $a0,17000    
    
# Animacion    
    
li $t0,0b0001
sw $t0,PORTD
   
jal sleep
    
li $t0,0b0011
sw $t0,PORTD
   
jal sleep
    
li $t0,0b0111
sw $t0,PORTD
   
jal sleep
    
li $t0,0b1111
sw $t0,PORTD
   
jal sleep
    
li $t0,0b1110
sw $t0,PORTD
   
jal sleep
    
li $t0,0b1100
sw $t0,PORTD
   
jal sleep
    
li $t0,0b1000
sw $t0,PORTD
    
jal sleep
    
li $t0,0b0000
sw $t0,PORTD
    
jal sleep
    
# Pego la vuelta
    
li $t0,0b1000
sw $t0,PORTD
    
jal sleep
    
li $t0,0b1100
sw $t0,PORTD
    
jal sleep
    
li $t0,0b1110
sw $t0,PORTD
    
jal sleep

li $t0,0b1111
sw $t0,PORTD
    
jal sleep
    
li $t0,0b0111
sw $t0,PORTD
    
jal sleep
    
li $t0,0b0011
sw $t0,PORTD
    
jal sleep
    
li $t0,0b0001
sw $t0,PORTD
    
jal sleep
    
li $t0,0b0000
sw $t0,PORTD
    
jal sleep     
    
    
       
    
animacion_perder_fin:    
    
lw $ra,($sp)
lw $s1,4($sp)    
addiu $sp,$sp,8       
    
 jr $ra   
    
animacion_ganar:
    
addiu $sp,$sp,-8
sw $ra,($sp)
sw $s1,4($sp)    
    
li $s1,0

animacion_ganar_loop:     
    
beq $s1,3,animacion_ganar_fin
     
li $t0,0xF
sw $t0,PORTD

li $a0,30000    
jal sleep
    
sw $0,PORTD
    
li $a0,30000    
jal sleep    
    
addiu $s1,$s1,1
    
j animacion_ganar_loop    
    
animacion_ganar_fin:    
    
lw $ra,($sp)
lw $s1,4($sp)    
addiu $sp,$sp,8    
    
jr $ra    
    
    
    
    