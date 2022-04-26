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
###############################################################################################
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
    mul $t2, $t2, 4	# get place to store in checker array
    
    lw $t3, top($t0) # get the address of top
    subi $t3, $t3, 7 # move top pointer up a row
    sw $t3, top($t0)


    sw $a2, board($t2) # insert the token
    
	move $s5, $ra
	jal place_token
	jal token_drop_noise
	move $ra, $s5
	
        #sw $t1, board($t2) # insert the token
	jr $ra

unPlace:
	move $t0, $a1 #get the column to take the piece out of
	sll $t0, $t0, 2 #change the offset
	lw $t2, top($t0) #get the space to unplace the token
	sll $t2, $t2, 2 #shift that space by 4 to align with board
	
	#change top to 7 more
	lw $t3, top($t0)
	addi $t3, $t3, 7
	sw $t3, top($t0)
	
	#clear out board at board($t3 * 4)
	sll $t2, $t3, 2
	sw $zero, board($t2)
	
	jr $ra

placeTemp:
	move $t0, $a1 # get the column to place in
    mul $t0, $t0, 4
    lw $t2, top($t0) # get the space to place token
    mul $t2, $t2, 4
    move $t1, $a0 # get the color to place
    
    
    lw $t3, top($t0) # get the address of top
    subi $t3, $t3, 7
    sw $t3, top($t0)
       
    sw $t1, board($t2) # insert the token
    
    jr $ra

###############################################################################################
# AI ALGORITHM
###############################################################################################

algorithm:
	# first check if column 4 bottom is free : board + 38 * 4 = board + 152
	li $t0, 152
	lw $t0, board($t0)
	# if this place is 0, then place it
	li $t1, 3
	beqz $t0, ai_final_place
	
    ###ai_place_loop_1 beg - Save the return address
    subi $sp, $sp, 4
    sw $ra, 0($sp)

    li $v0, 0
    jal ai_place_loop_1

    #restore the return address
    lw	$ra, 0($sp) 	
    addi $sp, $sp, 4
    ### ai_place_loop_1 end
    move $t1, $v0
	bgez $v0, ai_final_place #$v0 is the column where we will place it
	
	
	###ai_place_loop_2 beg - Save the return address
    subi $sp, $sp, 4
    sw $ra, 0($sp)

    li $v0, 0
    jal ai_place_loop_2

    #restore the return address
    lw	$ra, 0($sp) 	
    addi $sp, $sp, 4
    ### ai_place_loop_1 end
    move $t1, $v0
	# bgez $v0, ai_final_place #$v0 is the column where we will place it
	
	
	# once a position is decided, we will jump to this function
	# @param - $t1 the column index where it will be placed
  ai_final_place:
    #print
    add $a0, $t1, 1 # put column index + 1 to be printed
    li $v0, 1
    syscall
    la $a0, new_line
    li $v0, 4
    syscall
    #end print
    
    ### Save the return address
    subi $sp, $sp, 4
    sw $ra, 0($sp)

    li $a0, 1 # 1 - robot placing it
    move $a1, $t1 # column index
    jal place

    #restore the return address
    lw	$ra, 0($sp) 	
    addi $sp, $sp, 4
    ###
    
    jr $ra
    
# will check if placing pieces in any of the 7 spots makes a game over
# returns -1 if no column found
# returns column index if column found
# $v0
ai_place_loop_1:
	# $t0 - column index under consideration
	li $s2, -1
  ai_place_loop_1_beg:
	addi $s2, $s2, 1
  	bge $s2, 7, ai_place_loop_1_end

	### Save the return address
    subi $sp, $sp, 4
    sw $ra, 0($sp)
    
    move $a0, $s2
    jal can_place

    #restore the return address
    lw	$ra, 0($sp)
    addi $sp, $sp, 4
    ###
    beq $v0, 0, ai_place_loop_1_beg # if invalid, go to next index
    
    #valid - check by placing a -1 at this column and running checker on it
    # ----Check 1----
    ### Save the return address
    subi $sp, $sp, 4
    sw $ra, 0($sp)
    
    move $a1, $s2 #column
    li $a0, -1 #color
    jal placeTemp

    #restore the return address
    lw	$ra, 0($sp)
    addi $sp, $sp, 4
    ###
    
    ### Save the return address
    subi $sp, $sp, 4
    sw $ra, 0($sp)
    
    jal checker

    #restore the return address
    lw	$ra, 0($sp)
    addi $sp, $sp, 4
    ###
    
    ### Save the return address
    subi $sp, $sp, 4
    sw $ra, 0($sp)
    
    move $a1, $s2 #column
    jal unPlace

    #restore the return address
    lw	$ra, 0($sp)
    addi $sp, $sp, 4
    ###
    move $s0, $v0
    
    # ----Check 2----
    #valid - check by placing a 1 at this column and running checker on it
    ### Save the return address
    subi $sp, $sp, 4
    sw $ra, 0($sp)
    
    move $a1, $s2 #column
    li $a0, 1 #color
    jal placeTemp

    #restore the return address
    lw	$ra, 0($sp)
    addi $sp, $sp, 4
    ###
    
    ### Save the return address
    subi $sp, $sp, 4
    sw $ra, 0($sp)
    
    jal checker

    #restore the return address
    lw	$ra, 0($sp)
    addi $sp, $sp, 4
    ###
    
    ### Save the return address
    subi $sp, $sp, 4
    sw $ra, 0($sp)
    
    move $a1, $s2 #column
    jal unPlace

    #restore the return address
    lw	$ra, 0($sp)
    addi $sp, $sp, 4
    ###
    move $s1, $v0
    
    or $t1, $s0, $s1 #if both placements are zero, then we go back to the loop
    beqz $t1, ai_place_loop_1_beg
    # if it's not zero, then return this column
    move $v0, $s2
    jr $ra
    
  ai_place_loop_1_end:
  	# did not find any potential game winning moves on the next turn lul
	li $v0, -1
	jr $ra

# will look for the highest playable piece
# will always return a valid column
# returns column index
# $v0
ai_place_loop_2:
	# $t0 - column index in loop
	li $s0, -1
	# $t1 - min top number found so far
	li $s1, 41
	# $t2 - highest column index found so far
	li $s2, 0
	
  ai_place_loop_2_beg:
	addi $s0, $s0, 1
	bge $s0, 7, ai_place_loop_2_end
	### Save the return address
    subi $sp, $sp, 4
    sw $ra, 0($sp)
    
    move $a0, $s0
    jal can_place

    #restore the return address
    lw	$ra, 0($sp)
    addi $sp, $sp, 4
    ###
    beq $v0, 0, ai_place_loop_2_beg # if invalid, go to next index
    
    #valid - check if top($t0) is less than $t1, if so, change $t1 to top($t0) and change $t2 to $t0
    lw $t3, top($s0)
    bgt $t3, $s1, ai_place_loop_2_beg
    
    move $s1, $t3
    move $s2, $s0

  ai_place_loop_2_end:
	# put highest col found into $v0 and return it
	move $v0, $s2
	jr $ra