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
#                // check for tie somehow
#        }
################################################################# 
#Instantiate the global variables and create labels for the functions
	.data 

board:	 .space 168

#Initializes the indices where the highest token is located in each column: at first it starts at the bottom row
top:	 .word 35, 36, 37, 38, 39, 40, 41

#Function to check if the game is over
#Input: the board
#Output: 1 if the game is over, 0 if it is not

	.text
while:

endWhile:





