.data
string: .space 100 # Reservando 100 bytes no m�ximo para ass string
caps_string: .space 100

.text
# Lendo uma string como input
addi $v0, $zero, 8
la $a0, string # Colocando o valor do input no registrador $a0
addi $a1, $zero, 100
syscall

# S� sai do loop quando $t0 for igual ao caractere nulo (0)
lb $t0, string # inicialmente pega o primeiro caractere da string s� pra entrar no loop
j loop
loop: 	beq $t0, $zero, fim
	lb $t0, string($t1) # Selecionando um byte da string
	addi $t1, $t1, 1 # Somando 1 no endere�o pra pegar o pr�ximo byte na pr�xima execu��o do loop
	
	# Verificando se o caractere � mai�sculo
	slti $t2, $t0, 91
	slti $t3, $t0, 65
	
	# Se $t2 for verdadeiro e $t3 for falso a letra � mai�scula
	slt $t4, $t3, $t2 # Se $t3 for menor do que $t2, isto � se $t3 for 0 e $t2 for 1, $t4 � atualizado com 1
	bne $t4, $zero, caps
	j loop

caps: 	sb $t0, caps_string($t5) # Armazenando na string caps_string
	addi $t5, $t5, 1 # Somando um pra armazenar na pr�xima posi��o na pr�xima execu��o do caps
	j loop

# Fim
fim: 	addi $v0, $zero, 10
	syscall
