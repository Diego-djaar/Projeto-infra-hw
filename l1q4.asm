li $t0, 1664525 # add constant
li $t1, 1013904223 # mult constant

li $v0, 41 # gera inteiro aleatório, armazena em a0
####### tem como gerar inteiro sem sinal? teoricamente é só ler o registrador como uint
syscall

li $t2, 0 # i = 0
li $t3, 10 # n = 10

li $v0 1 # syscall: imprimir seed

beq $v0, $v0, loop # if (v0 = v0 ) - > loop 
##### tem jeito menos idiota de fazer ele entrar no loop?

loop:  	# for i in range(10)
	mulu $a0, $t1, $a0 # seed *= m-constant 
	#### a0 armazena apenas 32 bits menos significativos: 
	#### é pra pegar tudo? 32 bits + sig estão no endereço hi
	addu $a0, $a0, $t0 # seed += a-constant
	syscall # print(a0)
	addi $t1, $t2, 1 # i++
	bne $t2, $t3, loop # if i != 10 -> loop  (i de 1 a 10, primeira iteração i já é 1)





