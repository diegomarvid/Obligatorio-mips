.globl main
    
.text
    
.ent main
    
    main:
    
    # SETUP
    
    # SALIDAS
    
    # RD0,RD1,RD2,RD3
    
    # PINES:
    
    # 3,5,6,9
    
    # ENTRADAS
    
    # RE0,RE1,RE2,RE3
    
    # 26 ,27,28,29
   
    
    setup:
    
    # CONFIGURACION SALIDA
    
    
    # Configurar puerto D como salida
    li $t0, 0 
    sw $t0, TRISD
    sw $t0, TRISF
    
    # CONFIGURACION ENTRADA
    
    # Configurar puerto E como entrada
    li $t0, 15
    sw $t0, TRISE
    
    # 15 -> 00001111 
    
    # TIMERS
    # T2CON = 
    
    li $t0,0b00000101
    sw $t0,T2CON
    
    li $t0,0x8000
    sw $t0,T2CONSET


   
     init:
     
     # Dejo leds prendidos como MENU
     # li $t0,15
     li $t0,0
     sw $t0,PORTD
     
    
     
     evaluar:
     lw $t0,PORTE
     beq $t0,1,prender
     
     j evaluar
     
     prender:
     
     jal test_random
     
     j evaluar
    
     
     
     
#      
#      esperar:
#      
#      lw $t0,PORTE
#      
#      beq $t0,1,normal
#      beq $t0,2,normal
#      beq $t0,4,rewind
#      beq $t0,8,rewind     
#      
#      j esperar
#           
#      # Evaluo modos
#      
#      normal:
#      
#      li $a0,1
#      
#      j jugar
#      
#      rewind:
#      
#      li $a0,2
#      
#      j jugar
#     
#      jugar:
#        
#      # jal juego
#     
#     
#     # Termino de jugar, vuelvo a modo de espera
#      beq $v0,0,init
    
    
    
    fin:
    
.end main


