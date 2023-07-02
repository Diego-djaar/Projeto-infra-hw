.data
array: .word 3 4 7 8 9
array_size: .word 5

.text
# Recebe inteiro buscado
addi $v0, $zero, 5
syscall
add $s0, $v0, $zero # $s0 vai receber o num do input

# Busca binária recursiva
li $t0, 0 # $t0 vai apontar para o começo do array
lw $t1, array_size # $t1 vai apontar para o fim do array
addi $t1, $t1, -1

j loop

loop:	slt $t2, $t1, $t0 # Se fim < inicio significa que o valor não foi encontrado
	bne $t2, $zero, not_found # Valor não encontrado
	
	# Meio = inicio + fim / 2
	add $t3, $t0, $t1
	addi $t4, $zero, 2
	div $t3, $t4
	mflo $t3 # $t3 == meio
	
	# colocando no $t6 o array[meio]
	addi $t4, $zero, 4
	mult $t3, $t4
	mflo $t5
	lw $t6, array($t5)
	
	# if array[meio] == $s0 -> found
	beq $t6, $s0, found
	bgt $s0, $t6, recursao_metade_superior # Se num > meio -> busca recursiva com inicio = meio + 1
	j recursao_metade_inferior
	
recursao_metade_superior: # Novo valor de início = meio + 1
	addi $t0, $t3, 1
	j loop

recursao_metade_inferior: # Novo valor de fim = meio - 1
	addi $t1, $t3, -1
	j loop
	
found:	addi $v0, $zero, 1 # Armazenando 1 no registrador $v0
	add $v1, $zero, $t3 # Armazenando índice de n no $v1
	j fim

not_found: 
	addi $v0, $zero, 2 # Armazenando 2 no registrador $v0
	j fim


fim: 	addi $v0, $zero, 10
	syscall
