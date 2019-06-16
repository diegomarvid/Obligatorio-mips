.eqv enable 0xFFFF0012
.eqv scanner 0xFFFF0014

.globl get_play

.data


.text


#**********LEO DIGITAL LAB*********#

# $v0 -> color seleccionado
# $v0 -> -1 | No selecciono nada en
# su intervalo dado

get_play:

addiu $sp,$sp,-8
sw $ra,($sp)
sw $s0,4($sp)

#Valor inicial -> no apreto teclas
li $s0,-1

#Mi tiempo inicial
li $v0,30
syscall
move $t3,$a0

get_play_loop:

#Mi tiempo actual
li $v0,30
syscall
move $t4,$a0

#Calculo diferencia de tiempo
subu $t4,$t4,$t3

#Evaluo si estoy en menos tiempo del maximo (2s)
bgt $t4,2000,get_play_fin

#Prendo fila 1
li $t1,1
sb $t1,enable
lbu $t0,scanner

beq $t0, 0x11, cuadrante_1
beq $t0, 0x21, cuadrante_1
beq $t0, 0x41, cuadrante_2
beq $t0, 0x81, cuadrante_2

#Prendo fila 2
li $t1,2
sb $t1,enable
lbu $t0,scanner

beq $t0, 0x12, cuadrante_1
beq $t0, 0x22, cuadrante_1
beq $t0, 0x42, cuadrante_2
beq $t0, 0x82, cuadrante_2

#Prendo fila 3
li $t1,4
sb $t1,enable
lbu $t0,scanner	

beq $t0, 0x14, cuadrante_4
beq $t0, 0x24, cuadrante_4
beq $t0, 0x44, cuadrante_3
beq $t0, 0x84, cuadrante_3

#Prendo fila 4
li $t1,8
sb $t1,enable
lbu $t0,scanner

beq $t0, 0x18, cuadrante_4
beq $t0, 0x28, cuadrante_4
beq $t0, 0x48, cuadrante_3
beq $t0, 0x88, cuadrante_3


j get_play_loop

#Evaluo que color es que cuadrante
#Y lo guardo en s0

cuadrante_1:

li $a0,0
jal cuadrante_color

move $s0,$v0

j get_play_fin

cuadrante_2:

li $a0,1
jal cuadrante_color

move $s0,$v0

j get_play_fin

cuadrante_3:

li $a0,2
jal cuadrante_color

move $s0,$v0

j get_play_fin

cuadrante_4:

li $a0,3
jal cuadrante_color

move $s0,$v0

j get_play_fin

get_play_fin:

move $v0,$s0

lw $ra,($sp)
lw $s0,4($sp)
addiu $sp,$sp,8

jr $ra

#**********CUADRANTE COLOR*********************#

# $a0 - > Cuadrante seleccionado

cuadrante_color:

li $v0,-1

# Me fijo a que color hace referencia el cuadrante:

lw $t0,green_cord
beq $a0,$t0,cuadrante_color_green

lw $t0,red_cord
beq $a0,$t0,cuadrante_color_red

lw $t0,yellow_cord
beq $a0,$t0,cuadrante_color_yellow

lw $t0,blue_cord
beq $a0,$t0,cuadrante_color_blue

j cuadrante_color_fin

cuadrante_color_green:
li $v0,0
j cuadrante_color_fin

cuadrante_color_red:
li $v0,1
j cuadrante_color_fin

cuadrante_color_blue:
li $v0,2
j cuadrante_color_fin

cuadrante_color_yellow:
li $v0,3
j cuadrante_color_fin

cuadrante_color_fin:

jr $ra




