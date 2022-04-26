.data  
    new_line: .asciiz "\n"
    #board: 
    #    .align 2
    #    .word 0,0,0,0,0,0, 0,0,0,0,0,0, 0,0,0,0,0,0, 0,0,0,0,0,0, 0,0,0,0,0,0, 1,0,0,0,0,0, 1,0,0,0,0,1

    .text

.globl place
.globl can_place
.globl algorithm
li $a0, 0
li $a1, 1
j place
# PLACING CHECKER
###############################################################################################
can_place: 
    move $t0, $a0
    mul $t0, $t0, 4
    lw $t1, top($t0)
    
    li $t2, 0
    blt $t1, $t2, cannot_place # if the column is not full, return 1
    j can_place_end # if the column is full, return 0

can_place_end:
    li $v0, 1
    jr $ra

cannot_place:
    li $v0, 0
    jr $ra
###############################################################################################


# PLACING TOKEN FUNCTIONS
###############################################################################################
place:
    move $t0, $a1 # get the column to place in
    move $a2, $a0	# get color
    move $a0, $t0	# get horizontal location
    mul $t0, $t0, 4
    lw $t2, top($t0) # get the space to place token
    div $a1, $t2, 7    # store row num
    
    lw $t3, top($t0) # get the address of top
    subi $t3, $t3, 7 # move top pointer up a row
    sw $t3, top($t0)
    
    move $t0, $a0	# column
    move $t1, $a1	# row
    move $t2, $a2       # color
    
    li $v0, 1
    syscall		# print column
    la $a0, new_line
    li $v0, 4
    syscall
    
    li $v0, 1
    move $a0, $t1	# print row
    syscall
    
    la $a0, new_line
    li $v0, 4
    syscall
    
    li $v0, 1
    move $a0, $a2
    syscall		# print color
    
    move $a0, $t0
    move $a1, $t1
    move $a2, $t2
    
	move $s5, $ra
	jal place_token
	move $ra, $s5
        #sw $t1, board($t2) # insert the token
	jr $ra
###############################################################################################


# PRINT BOARD
###############################################################################################

###############################################################################################
# AI ALGORITHM

algorithm:
    #Save the return address
    subi $sp, $sp, 4
    sw $ra, 0($sp)

    li $v0, 0
    jal ai_place_loop

    #restore the return address
    lw	$ra, 0($sp) 	
    addi $sp, $sp, 4

    jr $ra
    

ai_place_loop:
    # load a random number into $t0
    li $v0, 41     # Service 41, random int
    li $a0, 0          # Select random generator 0
    syscall            # Generate random int (returns in $a0)

    li $t1, 7
    divu $t1, $a0, $t1 # divide by 7 to get a number between 0 and 6
    mfhi $s1

    move $a0, $s1 # store the random number in $a0

    # Save the return address
    subi $sp, $sp, 4
    sw $ra, 0($sp)
    jal can_place

    #restore the return address
    lw	$ra, 0($sp) 	
    addi $sp, $sp, 4

    beq $v0, 0, ai_place_loop # if invalid, try again
    move $a1, $s1 # store the random number in $a1
    
    ###print
    #move $a0, $s1 # store the random number in $a0
    #li $v0, 1
    #syscall
    la $a0, new_line
    li $v0, 4
    syscall
    ###end print
    
    # Save the return address
    subi $sp, $sp, 4
    sw $ra, 0($sp)

    li $a0, 1
    jal place

    #restore the return address
    lw	$ra, 0($sp) 	
    addi $sp, $sp, 4

    jr $ra

test_thing:
	jr $ra
