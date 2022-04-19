.data  
    new_line: .asciiz "\n"
    #board: 
    #    .align 2
    #    .word 0,0,0,0,0,0, 0,0,0,0,0,0, 0,0,0,0,0,0, 0,0,0,0,0,0, 0,0,0,0,0,0, 1,0,0,0,0,0, 1,0,0,0,0,1

    .text

.globl print_board
.globl place
.globl can_place
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
