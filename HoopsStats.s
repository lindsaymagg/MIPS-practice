.data
	namep: .asciiz "Enter name: "
	jerseyp: .asciiz "Enter jersey: "
	ppgp: .asciiz "Enter average points per game: "
	gradp: .asciiz "Enter grad year: "
	newline: .asciiz "\n"
	done: .asciiz "DONE\n"
	end: .asciiz "we outttie"
	debug: .asciiz "debugging. here"
	debug2: .asciiz "debugging. here2"
	.align 2

.text
	main: 
	#HEAD WILL BE STORED IN $t6

	getinput: # Make new node!

	# Allocate space for new node.
	li $v0, 9
	li $a0, 116
	syscall
	move $t7, $v0 # Store address of this node in #t7

# NAME
	# Ask for name
	li $v0, 4
	la $a0, namep
	syscall

	# Get name from user
	li $v0, 8

	# $a0 should hold address you wanna store name in
	la $a0, 0($t7)

	# $a1 should hold number of bytes
	li $a1, 100
	syscall

	# Name should now begin at $t7!

	move $s0, $t7 # copy name pointer from $t7 t0 $s0
	la $t5, done
	move $s1, $t5 # copy DONE pointer to $s1

	jal checkdone

# JERSEY
	# Ask for jersey
	li $v0, 4
	la $a0, jerseyp
	syscall

	# Get integer from user. int will be in $v0
	li $v0, 5
	syscall

	# Store integer at address after name
	sw $v0, 100($t7)

# AV PPG
	# Ask for av points per game
	li $v0, 4
	la $a0, ppgp
	syscall

	# Get float from user
	li $v0, 6
	syscall
	# Float is now in $f0

	# Store float at address after jersey #
	s.s $f0, 104($t7)

# GRAD YEAR
	# Ask for graduation year
	li $v0, 4
	la $a0, gradp
	syscall

	# Get integer from user
	li $v0, 5
	syscall

	# Store integer at address after name
	sw $v0, 108($t7)

# Name @ 0($7)
# Jersey @ 100($t7)
# Avg ppg @ 104($t7)
# Grad year @ 108($t7)
# Next pointer @ 112($t7) // currently null

	beqz $t6, firstNode # if this is the first player, set up head.

	# Am I greater than the first node?
	la $a0, 0($t7) # ME
	la $a1, 0($t6) # HEAD
	la $t2, 0($t6) # HEAD
	jal isGreaterThan

	move $s0, $v0 # move boolean value to $s0

	# If I am not greater than head, go to lessThanHead
	beqz $s0, lessThanHead

	# IF I AM GREATER... make me the new head.
	sw $t6, 112($t7)
	la $t6, 0($t7)

	j getinput

	lessThanHead:

		# Am I the second node we've seen so far?
		# If I'm the second, then head.next.next will be null
		# Address of old head is stored in $t2
		lw $t1, 112($t2)
		beqz $t1, connectMeToEnd

	makePointers:
	# $t4, $t2, --- t3, t6, and t7 are in use.
	
		move $t4, $t6 # PREV pointer in $t4. Currently points to head.
		lw $t2, 112($t4) # CURRPOINT. get address of node after head.

	insertNode:

		move $a0, $t7 # copy address of ME to a0
		move $a1, $t2 # copy address of CurrPoint to a1
		# Is currNode greater than next node?
		jal isGreaterThan

		move $t1, $v0 # $t1 is either 1 or 0
		beqz $t1, lesser

		greater:
			# currNode IS greater. So link properly here.
			# prev.next should get me
			sw $t7, 112($t4)
			# me.next = currpointer
			sw $t2, 112($t7)

			j getinput

		lesser:

			currPointLast:
			# See if currpointer.next is null
			# Curr point is $t2
			lw $t5, 112($t2) # changed la to lw

			bnez $t5, notLast
		
			j connectMeToEnd


			notLast:
			# prev becomes currentPoint
			move $t4, $t2
			# currentPoint gets currentPoint.next
			lw $t2, 112($t2) #changed sw to lw

			j insertNode




####DONOTTOUCH___________________________________________________!!!!!
	
	firstNode: # if this is the first player, store the addy in $t6 

		la $t6, 0($t7)
		j makeMeLast


	connectMeToEnd:

		# put my address into the next field of the last node
		sw $t7, 112($t3)

	makeMeLast:
		# Put my address in $t3 / make me the last node
		la $t3, 0($t7)
		# Make me point to no one
		sw $zero, 112($t3)

		j getinput


####DONOTTOUCH___________________________________________________!!!!!

	print:
		# Print entire linked list
		# Start with "current" at head. Curr = $t3
		la $t3, 0($t6)

		printnode:

		beqz $t3, exit

		# Print name
		li $v0, 4
		la $a0, 0($t3)
		syscall

		# Print character (space)
		li $v0, 11
		li $a0, 32
		syscall

		# Print jersey
		li $v0, 1
		lw $a0, 100($t3)
		syscall

		# Print space
		li $v0, 11
		li $a0, 32
		syscall

		# Print grad year
		li $v0, 1
		lw $a0, 108($t3)
		syscall

		# Print new line
		li $v0, 4
		la $a0, newline
		syscall

		# Update current node
		lw $t3, 112($t3)

		j printnode

	checkdone:
		lb $t0, ($s0) # Name is in $s0 
		lb $t2, ($s1) # Done is in $s1
		bne $t0, $t2, continue # if not same char, get jersey
		beq $t0, $zero, print # if reach end, equal
		addi $s0, $s0, 1 # point to next char of name
		addi $s1, $s1, 1 # point to next char of done
		j checkdone
		
	continue: # Remove newline character, then keep gathering info.
		# Are we at null character?
		beq $t0, $zero, atnull
		addi $s0, $s0, 1 # point to next char of name
		lb $t0, ($s0) # Name is in $s0
		j continue

		atnull:
		addi $s0, $s0, -5 # Go back two characters
		sb $0, 4($s0) # Replace with eos character

		jr $ra

	isGreaterThan: # return 1 if a0 > a1, return 0 if a0 < a1
		# a0 is the address of the current node we are adding to the list
		# a1 is the address of node in the list
		move $s0, $a0 # put a0 into s0
		move $s1, $a1 # put a1 into s1
		l.s $f3, 104($s0) # CURR
		l.s $f4, 104($s1) # previously existing node

		# if two avg_pgg are equal, compare strings
		c.eq.s $f3, $f4
		bc1t compstring

		c.lt.s $f4, $f3 # if f4 < f3, 1 goes in thing
		bc1t troo
		
		falze: # less than
		li $v0, 0
		jr $ra
		
		troo: # greater than
		li $v0, 1
		jr $ra

		compstring: # Need to compare two names.
			lb $t0, ($s0) # Current name is in $s0 
			lb $t1, ($s1) # Node we are comparing with is in $s1
			bne $t0, $t1, whoBigger
			addi $s0, $s0, 1 # point to next char of name
			addi $s1, $s1, 1 # point to next char of done

			j compstring

		whoBigger:
			slt $s2, $t1, $t0 # put 1 in $s2 if a0 > a1
			beqz $s2, troo
			j falze

	exit: # end program
		li $v0, 10
		syscall

