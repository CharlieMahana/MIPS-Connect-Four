################### Checker for horizontals of the board ################### 
#  Overall Program Functional Description: 
#This function is meant to check whether a player 1 or player 2 has won the game 
#or neither has won the game for the horizontals of the board.
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
#    t0 = 0;//row
#      while(t0 < 6){
#          t7 = 0;//total sum
#          t2 = t0 * 7;//starting index
#          t3 = board[t2];//0
#          t7 += t3;
#          t2 += 1;
#          t4 = board[t2];//1
#          t7 += t4;
#          t2 += 1;
#          t5 = board[t2];//2
#          t7 += t5;
#          t2 += 1;
#          t6 = board[t2];//3
#          t7 += t6;
#          t2 += 1;
#          //check if t7 is 4/-4. Make a subroutine for that
#          if(t7 == -4)
#              goto _checker_end;
#          if(t7 == 4)
#              goto _checker_end;
#          //subtract 0 from total sum
#          t7 -= t3;
#          //set 0 to 4
#          t3 = board[t2];//4
#          t7 += t3;
#          t2 += 1;
#          //check if t7 is 4/-4. Make a subroutine for that
#          if(t7 == -4)
#              goto _checker_end;
#          if(t7 == 4)
#              goto _checker_end;
#          //subtract 1 from total sum
#          t7 -= t4;
#          //set 1 to 5
#          t4 = board[t2];//5
#          t7 += t4;
#          t2 += 1;
#          //check if t7 is 4/-4. Make a subroutine for that
#          if(t7 == -4)
#              goto _checker_end;
#          if(t7 == 4)
#              goto _checker_end;
#          //subtract 2 from total sum
#          t7 -= t5;
#          //set 2 to 6
#          t5 = board[t2];//6
#          t7 += t5;
#          t2 += 1;
#          //check if t7 is 4/-4. Make a subroutine for that
#          if(t7 == -4)
#              goto _checker_end;
#          if(t7 == 4)
#              goto _checker_end;
#
#          t0++;
#      }
################################################################# 

    .text

.globl check_horizontal

check_horizontal:
#Set row and col to 0
add		$t0, $0, $0 

while:
    #If col is less than 6
    bge		$t1, 6, endWhile # if $t0 >= $t1 then target
    #Set t7 to 0; t7 is the total sum
    add		$t7, $0, $0

    #Set t2 to t0 * 7 
    #t2 is starting index
    mul	    $t2, $t0, 7			    # $t0 * 7 = $t2
    #Make $t2 word aligned
    sll		$t2, $t2, 	2		# $t2 = $t2 << 2

    #0
    lw  	$t3, board($t2)     # $t3 = board[t2]; Get the value of the board at the index
    add		$t7, $t7, $t3        # $t7 = $t7 + $t3; Add the value of the board at the index to the total sum

    #1
    add		$t2, $t2, 4 # $t2 = $t2 + 1*4; Add 1 to the index
    lw		$t4, board($t2)     # $t4 = board[t2]; Get the value of the board at the index
    add		$t7, $t7, $t4        # $t7 = $t7 + $t4; Add the value of the board at the index to the total sum

    #2
    add		$t2, $t2, 4 # $t2 = $t2 + 1*4; Add 1 to the index
    lw		$t5, board($t2)     # $t5 = board[t2]; Get the value of the board at the index
    add		$t7, $t7, $t5        # $t7 = $t7 + $t5; Add the value of the board at the index to the total sum

    #3
    add		$t2, $t2, 4 # $t2 = $t2 + 1*4; Add 1 to the index
    lw		$t6, board($t2)     # $t6 = board[t2]; Get the value of the board at the index
    add		$t7, $t7, $t6        # $t7 = $t7 + $t6; Add the value of the board at the index to the total sum

    #If t7 is -4
    beq		$t7, -4, _computer_wins # if $t7 == -4 then computer wins
    #If t7 is 4
    beq		$t7, 4, _human_wins # if $t7 == 4 then human wins

    #Subtract 0 from total sum
    sub		$t7, $t7, $t3        # $t7 = $t7 - $t3; Subtract the value of the board at the index from the total sum

    #Set 1 to 4
    #4
    add		$t2, $t2, 4 # $t2 = $t2 + 1*4; Add 1 to the index
    lw		$t3, board($t2)     # $t3 = board[t2]; Get the value of the board at the index
    add		$t7, $t7, $t3        # $t7 = $t7 + $t3; Add the value of the board at the index to the total sum

    #If t7 is -4
    beq		$t7, -4, _computer_wins # if $t7 == -4 then computer wins
    #If t7 is 4
    beq		$t7, 4, _human_wins # if $t7 == 4 then human wins

    #Subtract 1 from total sum
    sub		$t7, $t7, $t4        # $t7 = $t7 - $t3; Subtract the value of the board at the index from the total sum

    #Set 2 to 5
    #5
    add		$t2, $t2, 4 # $t2 = $t2 + 1*4; Add 1 to the index
    lw		$t4, board($t2)     # $t6 = board[t2]; Get the value of the board at the index
    add		$t7, $t7, $t4        # $t7 = $t7 + $t6; Add the value of the board at the index to the total sum

    #If t7 is -4
    beq		$t7, -4, _computer_wins # if $t7 == -4 then computer wins
    #If t7 is 4
    beq		$t7, 4, _human_wins # if $t7 == 4 then human wins

    #Subtract 2 from total sum
    sub		$t7, $t7, $t5        # $t7 = $t7 - $t3; Subtract the value of the board at the index from the total sum

    #Set 3 to 6
    #6
    add		$t2, $t2, 4 # $t2 = $t2 + 1*4; Add 1 to the index
    lw		$t5, board($t2)     # $t6 = board[t2]; Get the value of the board at the index
    add		$t7, $t7, $t5        # $t7 = $t7 + $t6; Add the value of the board at the index to the total sum

    #If t7 is -4
    beq		$t7, -4, _computer_wins # if $t7 == -4 then computer wins
    #If t7 is 4
    beq		$t7, 4, _human_wins # if $t7 == 4 then human wins

    #Increment row
    add		$t0, $t0, 1

endWhile:

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

