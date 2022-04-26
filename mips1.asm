################### Main game loop ################### 
#  Overall Program Functional Description: 
#This function is meant to hold the main game loop. It will
#call various help functions to update the game state, and
#give a high level description of the game.
################################################################ 
#  Pseudocode Description: 
#        while (1) {
#                printBoard();
#        _valid_input_col:
#                printf(
#                    "Please enter which column [1-7] you would like to play\n");
#                v0 = 0;
#                scanf("%d", &v0);
#                if (v0 < 1 || v0 > 7) {
#                        printf("Please enter a column within bounds\n");
#                        goto _valid_input_col;
#                }
#                a0 = v0 - 1;  // set a0 to col, which is v0 - 1
#                canPlace();
#                if (v0 == 0) {
#                        printf("Please enter a column that is not full\n");
#                        goto _valid_input_col;
#                }
#                a1 = a0;  // set a1 to col number, which is a0
#                a0 = -1;  // set a0 to color, which is -1
#                place();
#                checker();
#                printBoard();
#                algorithm();
#                checker();
#                // check for tie 
#        }
################################################################# 
#Instantiate the global variables and create labels for the functions
	.data 

wantToPlay: .asciiz "Please enter which column [1-7] you would like to play\n"
outOfBounds: .asciiz "Please enter a column within bounds\n"
colFull: .asciiz "Please enter a column that is not full\n"
humanWin: .asciiz "Human wins!\n"
robotWin: .asciiz "Robot wins!\n"
tie: .asciiz "TIE\n"

.align 2
board: .word 0,0,0,0,0,0, 0,0,0,0,0,0, 0,0,0,0,0,0, 0,0,0,0,0,0, 0,0,0,0,0,0, 0,0,0,0,0,0, 0,0,0,0,0,0

.align 2
#Initializes the indices where the highest token is located in each column: at first it starts at the bottom row
top:	 .word 35, 36, 37, 38, 39, 40, 41


	.text
    .globl board 
    .globl main
	.globl top
    main:

	#Count for how many moves

	jal initialize_graphics

	li 		$s1, 0
	
while:
	#jal 	print_board

	#Output wantToPlay
	li  	$v0, 4           # service 1 is print integer
    la		$a0, wantToPlay
    syscall
	j get_input 
	
	invalid_input:
	#Output outOfBounds
	li  	$v0, 4           # service 1 is print integer
    la		$a0, outOfBounds
    syscall
	j get_input 

	not_available:
	li  	$v0, 4           # service 1 is print integer
    la		$a0, colFull
    syscall

	get_input:
	#Get input
	li		$v0, 5           # service 5 is scanf
	syscall

	#Check if the user input is valid
	blt	$v0, 1 , invalid_input
	bgt	$v0, 7 , invalid_input

	#Check if the user input is available
	#save the input in s0 since v0 is used in can_place
	move	$s0, $v0
	subi 	$s1, $s0, 1 #set a0 to col, which is v0 - 1
	move $a0, $s1
	jal can_place
	beq	$v0, 0, invalid_input

	#Valid input
	move $a1, $s1 #set a1 to col number, which is a0
	li 	$a0, -1 #set a0 to color, which is -1
	jal place
	jal checker
	li $a0, 500
	li $v0, 32
	syscall
	beq		$v0, 1, _computer_wins # if $t0 == $t1 then target 
	beq		$v0, -1, _human_wins # if $t0 == $t1 then target
	# jal print_board
	jal algorithm #need to implement
	jal checker
	beq		$v0, 1, _computer_wins # if $t0 == $t1 then target 
	beq		$v0, -1, _human_wins # if $t0 == $t1 then target
	
	#Check for tie and increment number of moves
	addi	$s1, $s1, 2
	beq		$s1, 42 , _tie # if $t0 == $t1 then target
	j		while

endWhile:

_tie:
	#Output humanWin
	li  	$v0, 4           # service 1 is print integer
    la		$a0, tie
    syscall
	j end
_human_wins:
	#Output humanWin
	li  	$v0, 4           # service 1 is print integer
    la		$a0, humanWin
    syscall
	j end
_computer_wins:
	#Output robotWin
	li  	$v0, 4           # service 1 is print integer
    la		$a0, robotWin
    syscall

end:
li $v0, 10
    syscall
