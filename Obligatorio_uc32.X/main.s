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
   
    
    # CONFIGURACION SALIDA
    
    
    # Configurar puerto D como salida
    li $t0, 0 
    sw $t0, TRISD
    
    
    # CONFIGURACION ENTRADA
    
    # Configurar puerto E como entrada
    li $t0, 15
    sw $t0, TRISE
    
    # 15 -> 00001111 
    

    loop:
    
    # Obtengo valores de los botones
    
    
    lw $t4,PORTE
    
    # Guardo el valor de cada boton
    andi $t0,$t4,1
    andi $t1,$t4,2
    andi $t2,$t4,4
    andi $t3,$t4,8
    
    # Debouncing
    
    
    # Cargo el led con el valor del boton 
    sw $t4,PORTD
    
    j loop
    
.end main


