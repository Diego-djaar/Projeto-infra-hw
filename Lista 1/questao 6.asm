.data # Para testar o código basta modificar os valores de dividendo e divisor!!!
dividendo: .word 20
divisor: .word 10
error_str: .asciiz "Divisão por zero: resultado indeterminado"
RESULT: .word 0
REMAINDER: .word 0

.text
lw $s0, dividendo
lw $s1, divisor

# Testando o caso de divisão por zero
beqz $s1, error

# Verificando o sinal dos operandos
slti $t2, $s0, 0
slti $t3, $s1, 0

xor $t4, $t2, $t3 # Se $t2 e $t3 forem diferentes o sinal é negativo, então a flag $t4 fica 1

# Transformando o divisor e o dividendo em seus valores absolutos para os cálculos
abs $s0, $s0
abs $s1, $s1

j loop

# Faremos subtrações sequenciais até o dividendo ser menor do que o divisor
# $t0 será o contador
loop: 	slt $t1, $s0, $s1 # Se o dividendo for menor do que o divisor a flag $t1 fica 1
	bnez $t1, signal # Se for diferente de zero (se for 1) pula para os resultados
	
	sub $s0, $s0, $s1
	addi $t0, $t0, 1
	j loop

error:	# Divisão por 0
	la $a0, error_str
	addi $v0, $zero, 4
	syscall
	
	# Flag de divisão por zero fica 1
	addi $t9, $zero, 1
	
	j fim

signal: # Armazenar no result e no remainder os resultados
	bne $t4, $zero, negativo # Se $t4 for diferente de 0 significa que o resultado é negativo
	j resultado

resultado: # Armazenar no result e no remainder os resultados
	sw $s0, REMAINDER($zero)
	sw $t0, RESULT($zero)
	j fim

negativo: 
	li $t5, -1
	mult $t0, $t5
	mflo $t0
	j resultado

fim: 	addi $v0, $zero, 10
	syscall
	