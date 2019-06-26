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
    li $t0, 0xF
    sw $t0, TRISE
    
    # 15 -> 00001111 
    
    # TIMERS
    
    
    li $t0,0x8000
    sw $t0,T2CON # Modo
    
 
    init:
      
    # Dejo leds prendidos como MENU
    li $t0,0xF
    sw $t0,PORTD
     
     
    esperar:
     
    lw $t0,PORTE
    andi $t0,$t0,0b1111
     
    beq $t0,1,normal
    beq $t0,2,rewind
    beq $t0,4,fin
    beq $t0,8,fin     
     
    j esperar
          
    # Evaluo modos
     
    normal:
     
    li $a0,1
     
    j jugar
    
    rewind:
     
    li $a0,2
     
    j jugar
    
    jugar:
       
    jal juego
    
    j init
    
    
    fin:
    
    sw $0,PORTD
    
.end main


