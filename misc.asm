.data  
    new_line: .asciiz "\n"
    #board: 
    #    .align 2
    #    .word 0,0,0,0,0,0, 0,0,0,0,0,0, 0,0,0,0,0,0, 0,0,0,0,0,0, 0,0,0,0,0,0, 1,0,0,0,0,0, 1,0,0,0,0,1

    .text

.globl print_board
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
    
    li $t2, 7
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
    mul $t0, $t0, 4
    lw $t2, top($t0) # get the space to place token
    mul $t2, $t2, 4
    move $t1, $a0 # get the color to place
    
    
    lw $t3, top($t0) # get the address of top
    subi $t3, $t3, 7
    sw $t3, top($t0)
       
    
    j insert_token # find the top of the column

insert_token:
    sw $t1, board($t2) # insert the token
    j print_board
###############################################################################################


# PRINT BOARD
###############################################################################################


print_board:
    li $t0, 0 # counter for column
    j print_board_loop # start the loop

print_board_loop:
    lw $a0, board($t0) # start at the first one in the row
    li $v0, 1
    syscall
    addi $t0, $t0, 4 # move to the next column
    lw $a0, board($t0) # start at the first one in the row
    syscall
    addi $t0, $t0, 4 # move to the next column
    lw $a0, board($t0) # start at the first one in the row
    syscall
    addi $t0, $t0, 4 # move to the next column
    lw $a0, board($t0) # start at the first one in the row
    syscall
    addi $t0, $t0, 4 # move to the next column
    lw $a0, board($t0) # start at the first one in the row
    syscall
    addi $t0, $t0, 4 # move to the next column
    lw $a0, board($t0) # start at the first one in the row
    syscall
    addi $t0, $t0, 4 # move to the next column
    lw $a0, board($t0) # start at the first one in the row
    syscall
    addi $t0, $t0, 4 # move to the next column
    la $a0, new_line
    li $v0, 4
    syscall
    beq $t0, 168, print_board_end # if we are at the end of the board, return
    j print_board_loop # if we are not at the end of the board, continue

print_board_end:
    jr $ra


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
    subi $a1, $a1, 1 # add 1 to the random number
    
    ###print
    move $a0, $s1 # store the random number in $a0
    li $v0, 1
    syscall
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
