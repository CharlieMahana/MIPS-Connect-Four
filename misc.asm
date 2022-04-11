.data  
    new_line: .asciiz "\n"
    board: 
        .align 2
        .word 0,0,0,1,0,0, 0,1,0,0,0,0, 0,0,0,0,0,0, 0,0,0,0,1,0, 0,0,0,-1,0,0, 0,0,0,0,0,0, 0,0,0,1,0,0

    .text

#.globl misc

j print_board
# PLACING CHECKER
###############################################################################################
can_place: 
    lw $t1, board($a0) # get the value of the column
    beq $t1, $zero, can_place_end # if the column is full, return 0
    j cannot_place # if the column is not full, return 1

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
    move $a0, $t0 # get the column to place in
    move $a1, $t1 # get the color to place
    j find_top # find the top of the column

find_top:
    lw $t2, board($t0) # get the value of the column
    beq $t2, $zero, insert_token # if the column is empty, return 0
    addi $t0, $t0, 6 # if the column is not empty, move up 6 spaces
    j find_top

insert_token:
    sw $t1, board($t0) # insert the token
    jr $ra
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
    la $a0, new_line
    li $v0, 4
    syscall
    beq $t0, 168, print_board_end # if we are at the end of the board, return
    j print_board_loop # if we are not at the end of the board, continue

print_board_end:
    #jr $ra


###############################################################################################
