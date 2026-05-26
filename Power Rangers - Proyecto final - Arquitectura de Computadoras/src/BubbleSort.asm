addi $s0, $zero, 0
addi $s1, $zero, 36

loop_principal:
nop
nop
nop
beq $s0, $s1, fin_programa
addi $s2, $zero, 0

loop_interno:
nop
nop
nop
sub $t7, $s1, $s0
nop
nop
nop
beq $s2, $t7, siguiente_iteracion
lw $t0, 0($s2)
nop
nop
nop
lw $t1, 4($s2)
nop
nop
nop
slt $t2, $t1, $t0
nop
nop
nop
beq $t2, $zero, avanzar_indice
sw $t1, 0($s2)
sw $t0, 4($s2)

avanzar_indice:
addi $s2, $s2, 4
j loop_interno

siguiente_iteracion:
addi $s0, $s0, 4
j loop_principal

fin_programa:
j fin_programa