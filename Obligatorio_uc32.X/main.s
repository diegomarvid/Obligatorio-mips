.globl main
    
.text
    
.ent main
    
    main:
    
    # SETUP
    
    # SALIDAS
    
    # RD0,RD1,RD2,RD3
    
    # PINES:
    
    # 3,5,6,9
   
    
    # Configurar puerto G como entrada #RG7 -> 12
    li $t0, 128
    sw $t0, TRISG
    
    # Configurar puerto F como salida 4 RF1
    li $t0, 0 
    sw $t0, TRISF
    
    # Configurar puerto E como salida para gnd
    li $t0, 0 
    sw $t0, TRISE
    
    sw $t0,PORTE
    
    
    loop:
    
    # Obtengo valor del boton
    lw $t0,PORTG
    
    andi $t0,$t0,128
    
    # Debouncing
    
    
    
    
    
    
    # Cargo el led con el valor del boton
    
    # Paso a posicion de la 6 a la 1 para escribir en RF1 | 4
    srl $t0,$t0,6
    sw $t0,PORTF
    
    j loop
    
.end main


