
#Computes and prints out f(N), where N is an integer greater than zero 
#that is input to the program on the command line. f(N) = 4*N + [2*f(N-1)] + 3.
#The base case is f(0)=5. 

.text
#blahblahblah
main: 

# print prompt
	li $v0, 4
	la $a0, prompt
	syscall

	li $v0, 5 # get integer from user
	syscall

	# move integer to another register
	move $t0, $v0


	li $v0, 4 # print string
	la $a0, newline
	syscall

	move $a0, $t0

	jal recursion

	# end program
exit:

	move $t1, $v0

	li $v0, 1 # print integer
	move $a0, $t1
	syscall

	li $v0, 10
	syscall



# original n is in $t0
# n is in $a0
recursion:

	addi $sp, $sp, -8 # set up stack frame
	sw $ra, 4($sp) # save return address
	sw $s0, 0($sp) # save n
	
	# current n is in s0

	# base case
	# if (n == 0) {return 5;} set v0 = 5
	bnez $a0, foo
basecase:
	li $v0, 5
	j clean

foo:
	add $s0, $a0, 0 # copy $a0 (current n) to $s0
	addi $a0, $a0, -1 # pass (n-1) as arg
	jal recursion # do recursion using n-1 as arg

	# v0 is the result of the call using n-1
	addi $s3, $zero, 4 # $s3 now contains 4
	mul $s1, $s0, $s3 # 4*n
	addi $s3, $zero, 2 # $s3 now contains 2
	mul $s2, $v0, $s3 # 2*f(n-1)
	add $s1, $s1, $s2 # 4n + 2*f(n-1)
	addi $v0, $s1, 3 # 4n + 2*f(n-1) + 2. Return

clean:

	lw $s0, 0($sp) # restore $s0
	lw $ra, 4($sp) # restore $ra
	addi $sp, $sp, 8 # collapse frame
	jr $ra


.data
prompt: .asciiz "Enter an integer: "
newline: .asciiz "\n"
bye: .asciiz "bye"