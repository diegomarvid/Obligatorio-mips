.text
    get_play:
    
    
    TMR1 = 0
    
    loop_get_play:
    
    beq TMR1,10000,error_get_play
    
    # Cargo los botones
    lw $t4,PORTE
    
    beq $t4,1,jugada_verde
    beq $t4,2,jugada_rojo
    beq $t4,4,jugada_azul
    beq $t4,8,jugada_amrillo
    
    j loop_get_play
    
   jugada_verde:
    
   li $v0,0
   j fin_get_play
   
   jugada_rojo:
    
   li $v0,1
   j fin_get_play
   
   jugada_azul:
    
   li $v0,2
   j fin_get_play
   
   jugada_amrillo:
    
   li $v0,3
   j fin_get_play
   
   error_get_play:
    
   li $v0,-1
   j fin_get_play
   
   fin_get_play:
    
jr $ra 


