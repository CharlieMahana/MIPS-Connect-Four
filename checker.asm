################### Checker for whether the game is over ################### 
#  Overall Program Functional Description: 
#This function is meant to check whether a player 1 or player 2 has won the game 
#or neither has won the game.
#returns -1 if player has 4 in a row,
#0 if no 4 in a row, or 1 if computer has 4 in a row
################################################################ 
#  Register Usage in Main: 
#$a0:  used to pass the  address of an array to the function 
#$a1: used to pass the length parameter  “N” to the function    
################################################################ 
#  Pseudocode Description: 
#Check topleft 3x4 for 4 in a row (Diagonally to the right)
#Check topright 3x4 for 4 in a row (Diagonally to the left)
#Check horizontals for a 4 in a row
#Check verticals for a 4 in a row
#if no 4 in a row, return 0
################################################################# 
.data
    #board: .word 168
    .align 2

    #test cases

    #empty board
    #0,0,0,0,0,0,0
    #0,0,0,0,0,0,0
    #0,0,0,0,0,0,0
    #0,0,0,0,0,0,0
    #0,0,0,0,0,0,0
    #0,0,0,0,0,0,0
    #board: .word 0,0,0,0,0,0,0 0,0,0,0,0,0,0 0,0,0,0,0,0,0 0,0,0,0,0,0,0 0,0,0,0,0,0,0 0,0,0,0,0,0,0

    
    #human win
    #1,0,0,0,0,0,0
    #0,1,0,0,0,0,0
    #0,0,1,0,0,0,0
    #0,0,0,1,0,0,0
    #0,0,0,0,0,0,0
    #0,0,0,0,0,0,0
    #board: .word 1,0,0,0,0,0,0 0,1,0,0,0,0,0 0,0,1,0,0,0,0 0,0,0,1,0,0,0 0,0,0,0,0,0,0 0,0,0,0,0,0,0

    #human win
    #0,0,0,0,0,0,0
    #0,0,0,0,0,0,0
    #0,1,1,0,0,0,0
    #0,0,1,1,0,0,0
    #0,0,0,1,1,0,0
    #0,0,0,0,1,0,0
    #board: .word 0,0,0,0,0,0,0 0,0,0,0,0,0,0 0,1,1,0,0,0,0 0,0,1,1,0,0,0 0,0,0,1,1,0,0 0,0,0,0,1,0,0

    #computer win
    #-1,0,0,0,0,0,0
    #0,-1,0,0,0,0,0
    #0,0,-1,0,0,0,0
    #0,0,0,-1,0,0,0
    #0,0,0,0,0,0, 0
    #0,0,0,0,0,0, 0
    #board: .word -1,0,0,0,0,0,0 0,-1,0,0,0,0,0 0,0,-1,0,0,0,0 0,0,0,-1,0,0,0 0,0,0,0,0,0, 0 0,0,0,0,0,0, 0
    
    #neither
    #-1,0,0,0,0,0,0
    #0,1,0,0,0,0, 0
    #0,0,-1,0,0,0,0
    #0,0,0,-1,0,0,0
    #0,0,0,0,0,0, 0
    #0,0,0,0,0,0, 0
    #board: .word -1,0,0,0,0,0,0 0,1,0,0,0,0, 0 0,0,-1,0,0,0,0 0,0,0,-1,0,0,0 0,0,0,0,0,0, 0 0,0,0,0,0,0, 0

    #top right
    #human win
    #0,0,0,0,0,1,0
    #0,0,0,0,1,0,0
    #0,0,0,1,0,0,0
    #0,0,1,0,0,0,0
    #0,0,0,0,0,0,0
    #0,0,0,0,0,0,0
    # board: .word 0,0,0,0,0,1, 0,0,0,0,1,0, 0,0,0,1,0,0, 0,0,1,0,0,0, 0,0,0,0,0,0, 0,0,0,0,0,0, 0,0,0,0,0,0,

    #0,0,0,1,0,1,0
    #0,0,1,0,1,0,0
    #0,1,0,0,0,0,0
    #1,0,0,0,0,0,0
    #0,0,0,0,0,0,0
    #0,0,0,0,0,0,0
    #board: .word 0,0,0,1,0,1,0 0,0,1,0,1,0,0 0,1,0,0,0,0,0 1,0,0,0,0,0,0 0,0,0,0,0,0,0 0,0,0,0,0,0,0

    #0,0,0,0,0,1,0
    #0,0,0,0,0,-1,0
    #0,0,0,1,1,0,0
    #0,0,1,1,0,0,0
    #0,0,1,0,0,0,0
    #0,1,0,0,0,0,0
    #board: .word 0,0,0,0,0,1,0 0,0,0,0,0,-1,0 0,0,0,1,1,0,0 0,0,1,1,0,0,0 0,0,1,0,0,0,0 0,1,0,0,0,0,0

    #0,0,0,0,0,1,0
    #0,0,0,0,0,-1,0
    #0,0,0,1,1,-1,0
    #0,0,1,0,-1,0,0
    #0,0,1,-1,0,0,0
    #0,1,-1,0,0,0,0
    #board: .word 0,0,0,0,0,1,0 0,0,0,0,0,-1,0 0,0,0,1,1,-1,0 0,0,1,0,-1,0,0 0,0,1,-1,0,0,0 0,1,-1,0,0,0,0

    #horizontal
    #human win
    #0,1,0,1,1,0,0
    #0,0,0,0,0,0,0
    #0,0,0,0,0,0,0
    #0,0,1,1,1,1,0
    #0,0,0,0,0,0,0
    #0,0,0,0,0,0,0
    #board: .word 0,1,0,1,1,0,0 0,0,0,0,0,0,0 0,0,0,0,0,0,0 0,0,1,1,1,1,0 0,0,0,0,0,0,0 0,0,0,0,0,0,0

    #vertical
    #human win
    #0,0,-1,0,0,0,0
    #0,0,-1,0,0,0,0
    #0,0,-1,0,0,0,0
    #0,0,-1,0,0,0,0
    #0,0,0,0,0,0,0
    #0,0,0,0,0,0,0
    #board: .word 0,0,-1,0,0,0,0 0,0,-1,0,0,0,0 0,0,-1,0,0,0,0 0,0,-1,0,0,0,0 0,0,0,0,0,0,0 0,0,0,0,0,0,0

    #human win
    #0,0,0,0,0,0,0
    #0,0,0,0,1,0,0
    #0,0,1,0,1,0,0
    #0,0,1,0,1,0,0
    #0,0,0,0,1,0,0
    #0,0,1,0,0,0,0
    #board: .word 0,0,0,0,0,0,0 0,0,0,0,1,0,0 0,0,1,0,1,0,0 0,0,1,0,1,0,0 0,0,0,0,1,0,0 0,0,1,0,0,0,0

.text 
    .globl checker
    # .globl board 
    # .globl main
    # main:
    checker:

    #store return address on stack
    addiu $sp, $sp, -4
    sw		$ra, 0($sp)

    addiu $sp, $sp, -4
    jal		check_top_left				# jump to check_top_left and save position to $ra
    lw $v0, 0($sp)
    addiu $sp, $sp, 4
    bne	$v0, $zero, end # if $t0 != $t1 then target

    addiu $sp, $sp, -4
    jal		check_top_right				# jump to check_top_right and save position to $ra
    lw $v0, 0($sp)
    addiu $sp, $sp, 4
    bne		$v0, $zero, end # if $t0 != $t1 then target

    addiu $sp, $sp, -4
    jal		check_horizontal				# jump to check_horizontal and save position to $ra
    lw $v0, 0($sp)
    addiu $sp, $sp, 4
    bne		$v0, $zero, end # if $t0 != $t1 then target

    addiu $sp, $sp, -4
    jal		check_vertical				# jump to check_vertical and save position to $ra
    lw $v0, 0($sp)
    addiu $sp, $sp, 4
    bne		$v0, $zero, end # if $t0 != $t1 then target

    end:
    # li  $v0,10
    # syscall
    #restore return address from stack
    lw		$ra, 0($sp)		# 
    addiu $sp, $sp, 4
    jr $ra
    
