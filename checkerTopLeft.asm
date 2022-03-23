################### Checker for top left of the board ################### 
#  Overall Program Functional Description: 
#This function is meant to check whether a player 1 or player 2 has won the game 
#or neither has won the game for the top left of the board.
#returns -1 if player has 4 in a row,
#0 if no 4 in a row, or 1 if computer has 4 in a row
################################################################ 
#  Register Usage in Main: 
#No in parameters
#Out parameters:
#$v0 = -1 if computer has 4 in a row,
#$v0 = 1 if human has 4 in a row,
#$v0 = 0 neither has 4 in a row
################################################################ 
#  Pseudocode Description: 
#
# t0 = 0; //row
# t1 = 0; //col
# while(t0 < 3){//rows
#     while(t1 < 4){//cols
#         t7 = 0;//total sum
#         t2 = t0 * 7 + t1;//starting index
#         t3 = board[t2];
#         t7 += t3;
#         t2 += 8;
#         t4 = board[t2];
#         t7 += t4;
#         t2 += 8;
#         t5 = board[t2];
#         t7 += t5;
#         t2 += 8;
#         t6 = board[t2];
#         t7 += t6;
#         if(t7 == -4)
#             return -1;
#         if(t7 == 4)
#             return 1;
#         t1++;
#     }
#     t0++;
# }
################################################################# 


    .text

.globl check_top_left

check_top_left:
#Set row and col to 0
add		$t0, $0, $0 
add		$t1, $0, $0 

while1:
    #If row is less than 3
    bge		$t0, 3, endWhile1 # if $t0 >= $t1 then target
    while2:
        #If col is less than 4
        bge		$t1, 4, endWhile2 # if $t0 >= $t1 then target
        #Set t7 to 0; t7 is the total sum
        add		$t7, $0, $0

        #Set t2 to t0 * 7 + t1
        #t2 is starting index
        mul	    $t2, $t0, 7			    # $t0 * 7 = $t2
        add		$t2, $t2, $t1		# $t0 = $t1 + $t2; Add col to index

        #Make $t2 word aligned
        sll		$t2, $t2, 	2		# $t2 = $t2 << 2

        lw  	$t3, board($t2)     # $t3 = board[t2]; Get the value of the board at the index
        add		$t7, $t7, $t3        # $t7 = $t7 + $t3; Add the value of the board at the index to the total sum

        add		$t2, $t2, 28 # $t2 = $t2 + 8*4; Add 8 to the index
        lw		$t3, board($t2)     # $t3 = board[t2]; Get the value of the board at the index
        add		$t7, $t7, $t3        # $t7 = $t7 + $t3; Add the value of the board at the index to the total sum

        add		$t2, $t2, 28 # $t2 = $t2 + 8*4; Add 8 to the index
        lw		$t3, board($t2)     # $t3 = board[t2]; Get the value of the board at the index
        add		$t7, $t7, $t3        # $t7 = $t7 + $t3; Add the value of the board at the index to the total sum

        add		$t2, $t2, 28 # $t2 = $t2 + 8*4; Add 8 to the index
        lw		$t3, board($t2)     # $t3 = board[t2]; Get the value of the board at the index
        add		$t7, $t7, $t3        # $t7 = $t7 + $t3; Add the value of the board at the index to the total sum

        #If t7 is -4
        beq		$t7, -4, _computer_wins # if $t7 == -4 then computer wins
        #If t7 is 4
        beq		$t7, 4, _human_wins # if $t7 == 4 then human wins

        #Increment col
        add		$t1, $t1, 1

    endWhile2:

    #Increment row
    add		$t0, $t0, 1
    j		while1				# jump to while1 

endWhile1:
#No 4 in a row
li		$v0, 0
sw		$v0, 0($sp)
jr		$ra					# jump to $ra

_computer_wins:
li		$v0, -1 		
sw		$v0, 0($sp)
jr		$ra					# jump to $ra

_human_wins:
li		$v0, 1 		
sw		$v0, 0($sp)
jr		$ra					# jump to $ra
