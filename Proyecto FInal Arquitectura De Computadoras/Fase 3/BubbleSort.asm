.data
    arreglo:    .word 8, 3, 1, 9, 5, 2, 7, 4, 6  
    tamano:     .word 9  

.text
.globl main

main:
    lui $s0, 0x10010000       
    ori $s0, $s0, 0     
    
    lw $s1, 36($s0)     
    addi $s2, $s1, -1   

    addi $t0, $zero, 0   
bucle_externo:
    slt $at, $t0, $s2    
    beq $at, $zero, fin_sort 

    sub $t2, $s2, $t0    
    addi $t1, $zero, 0   

bucle_interno:
    slt $at, $t1, $t2    
    beq $at, $zero, avance_externo 

    add $t3, $t1, $t1    
    add $t3, $t3, $t3    
    add $t4, $s0, $t3    

    lw $t5, 0($t4)       
    lw $t6, 4($t4)       

    slt $at, $t6, $t5    
    beq $at, $zero, no_intercambiar 

    sw $t6, 0($t4)       
    sw $t5, 4($t4)       

no_intercambiar:
    addi $t1, $t1, 1     
    j bucle_interno

avance_externo:
    addi $t0, $t0, 1     
    j bucle_externo

fin_sort:
bucle_final:
    j bucle_final