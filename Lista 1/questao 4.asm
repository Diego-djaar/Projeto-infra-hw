.data
space: .byte ' '

.text
li $t0, 1664525 # add constant
li $t1, 1013904223 # mult constant

li $v0, 41 # gera inteiro aleatório, armazena em a0
syscall

li $t2, 0 # i = 0
li $t3, 10 # n = 10

li $v0, 36 # syscall: imprimir seed

j loop

loop:	beq $t2, $t3, fim # if i == 10 sai do loops
	mulu $a0, $t1, $a0 # seed *= m-constant 
	addu $a0, $a0, $t0 # seed += a-constant
	
	li $v0, 36 # syscall: imprimir seed
	syscall # print(a0)
	
	# Imprimindo um espaço entre os números
	addi $v0, $zero, 11
	lb $a0, space
	syscall
		
	addi $t2, $t2, 1 # i++
	j loop

fim: 	addi $v0, $zero, 10
	syscall
