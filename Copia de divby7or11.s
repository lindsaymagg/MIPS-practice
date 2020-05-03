.text

main: 
	# print prompt
	li $v0, 4
	la $a0, prompt
	syscall

	li $v0, 5 # get integer from user
	syscall

	# move integer to another register
	move $t0, $v0

	# if (n <= 0) return 0
	bltz $t0, exit
	beqz $t0, exit

	# set x = 7
	li $t1, 7

	# set counter = 0
	li $t2, 0


	#while counter != n
checkdiv:

	#debugging
	##li $v0, 4 # print string
	##la $a0, xis
	##syscall
	##li $v0, 1 # print x
	##move $a0, $t1
	##syscall

	# if (x%7 == 0 || x%11 == 0), jump to divisible
	rem $t3, $t1, 7
	beqz $t3, divisible
	rem $t3, $t1, 11
	beqz $t3, divisible


ender:
	# increment x by 1
	addi $t1, $t1, 1

	# if counter does not equal n, j whileloop.
	bne $t0, $t2, checkdiv

	# if counter does equal n, j exit.
	
	#debugging
	##li $v0, 4 # print string
	##la $a0, counteris
	##syscall

	##li $v0, 1 # print n
	##move $a0, $t0
	##syscall

	##li $v0, 1 # print counter
	##move $a0, $t2
	##syscall

	beq $t0, $t2, exit




divisible:

	# debugging
	##li $v0, 4
	##la $a0, isdivisible
	##syscall

	# print x  after
	li $v0, 1 # print integer
	move $a0, $t1
	syscall

	li $v0, 4 # print string
	la $a0, newline
	syscall

	# increase counter by 1
	addi $t2, $t2, 1

	# go to ender
	j ender

# end program
exit:

##print done
##li $v0, 4
##la $a0, done
##syscall

#end program
li $v0, 10
syscall

# n is in t0
# x is in t1
# counter is in t2


.data
prompt: .asciiz "Enter an integer: "
newline: .asciiz "\n"
##done: .asciiz "we're done."
##xis: .asciiz "x is "
##isdivisible: .asciiz "jumped to divisible! \n"
##counteris: .asciiz "counter is n \n"
