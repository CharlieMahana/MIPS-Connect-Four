#include <stdio.h>
#include <stdlib.h>

int t0, t1, t2, t3, t4, t5, t6, t7;//temps
int s0, s1, s2, s3, s4, s5, s6, s7;//saved temps
int a0, a1, a2, a3;//arguments
int v0, v1;//return messages
int board[42] = {
    0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,
    };//{Player: -1, Empty: 0, Computer: 1}
int top[7] = {35, 36, 37, 38, 39, 40, 41};

void checker();
void canPlace();
void place();
void algorithm();
void printBoard();

int main()
{
    /* code */
    while(1){
        printBoard();
        _valid_input_col:
        printf("Please enter which column [1-7] you would like to play\n");
        v0 = 0;
        scanf("%d", &v0);
        if(v0 < 1 || v0 > 7){
            printf("Please enter a column within bounds\n");
            goto _valid_input_col;
        }
        a0 = v0 - 1;//set a0 to col, which is v0 - 1
        canPlace();
        if(v0 == 0){
            printf("Please enter a column that is not full\n");
            goto _valid_input_col;
        }
        a1 = a0;//set a1 to col number, which is a0
        a0 = -1;//set a0 to color, which is -1
        place();
        checker();

        printBoard();
        algorithm();
        checker();
        //check for tie somehow
    }

    // checker();
    // printf("%d\n", v0);
    // a0 = 1;
    // canPlace();
    // printf("%d\n", v0);
    // return 0;
}
void checker(){
    //no arguments
    //returns -1 if player has 4 in a row, 0 if no 4 in a row, or 1 if computer has 4 in a row
    //topleft
    {
        t0 = 0; //row
        t1 = 0; //col

        while(t0 < 3){//rows
            while(t1 < 4){//cols
                t7 = 0;//total sum
                t2 = t0 * 7 + t1;//starting index
                t3 = board[t2];
                t7 += t3;
                t2 += 8;
                t4 = board[t2];
                t7 += t4;
                t2 += 8;
                t5 = board[t2];
                t7 += t5;
                t2 += 8;
                t6 = board[t2];
                t7 += t6;
                if(t7 == -4)
                    goto _checker_end;
                if(t7 == 4)
                    goto _checker_end;
                t1++;
            }
            t0++;
        }
    }
    //topright
    {
        t0 = 0; //row
        t1 = 3; //col

        while(t0 < 3){//rows
            while(t1 < 7){//cols
                t7 = 0;//total sum
                t2 = t0 * 7 + t1;//starting index
                t3 = board[t2];
                t7 += t3;
                t2 += 6;
                t4 = board[t2];
                t7 += t4;
                t2 += 6;
                t5 = board[t2];
                t7 += t5;
                t2 += 6;
                t6 = board[t2];
                t7 += t6;
                if(t7 == -4)
                    goto _checker_end;
                if(t7 == 4)
                    goto _checker_end;
                t1++;
            }
            t0++;
        }
    }
    //horizontal
    {
        t0 = 0;//row
        while(t0 < 6){
            t7 = 0;//total sum
            t2 = t0 * 7;//starting index
            t3 = board[t2];//0
            t7 += t3;
            t2 += 1;
            t4 = board[t2];//1
            t7 += t4;
            t2 += 1;
            t5 = board[t2];//2
            t7 += t5;
            t2 += 1;
            t6 = board[t2];//3
            t7 += t6;
            t2 += 1;
            //check if t7 is 4/-4. Make a subroutine for that
            if(t7 == -4)
                goto _checker_end;
            if(t7 == 4)
                goto _checker_end;
            //subtract 0 from total sum
            t7 -= t3;
            //set 0 to 4
            t3 = board[t2];//4
            t7 += t3;
            t2 += 1;
            //check if t7 is 4/-4. Make a subroutine for that
            if(t7 == -4)
                goto _checker_end;
            if(t7 == 4)
                goto _checker_end;
            //subtract 1 from total sum
            t7 -= t4;
            //set 1 to 5
            t4 = board[t2];//5
            t7 += t4;
            t2 += 1;
            //check if t7 is 4/-4. Make a subroutine for that
            if(t7 == -4)
                goto _checker_end;
            if(t7 == 4)
                goto _checker_end;
            //subtract 2 from total sum
            t7 -= t5;
            //set 2 to 6
            t5 = board[t2];//6
            t7 += t5;
            t2 += 1;
            //check if t7 is 4/-4. Make a subroutine for that
            if(t7 == -4)
                goto _checker_end;
            if(t7 == 4)
                goto _checker_end;

            t0++;
        }
    }
    //vertical
    {
        t0 = 0;//col
        while(t0 < 7){
            t7 = 0;//total sum
            t2 = t0;//starting index
            t3 = board[t2];//0
            t7 += t3;
            t2 += 7;
            t4 = board[t2];//1
            t7 += t4;
            t2 += 7;
            t5 = board[t2];//2
            t7 += t5;
            t2 += 7;
            t6 = board[t2];//3
            t7 += t6;
            t2 += 7;
            //check if t7 is 4/-4. Make a subroutine for that
            if(t7 == -4)
                goto _checker_end;
            if(t7 == 4)
                goto _checker_end;
            //subtract 0 from total sum
            t7 -= t3;
            //set 0 to 4
            t3 = board[t2];//4
            t7 += t3;
            t2 += 7;
            //check if t7 is 4/-4. Make a subroutine for that
            if(t7 == -4)
                goto _checker_end;
            if(t7 == 4)
                goto _checker_end;
            //subtract 1 from total sum
            t7 -= t4;
            //set 1 to 5
            t4 = board[t2];//5
            t7 += t4;
            t2 += 7;
            //check if t7 is 4/-4. Make a subroutine for that
            if(t7 == -4)
                goto _checker_end;
            if(t7 == 4)
                goto _checker_end;
            
            t0++;
        }
    }
    
    t3 = 0;//if a four in a row isn't found, then 0 will be returned
    _checker_end://only goes here if a four in a row is found
    v0 = t3;
    if(v0 == -1){
        printf("Player wins!\n");
        exit(EXIT_SUCCESS);
    }else if(v0 == 1){
        printf("Computer wins!\n");
        exit(EXIT_SUCCESS);
    }
}
void canPlace(){
    //a0 - column to check
    //v0 = 0 if can't place, 1 if can place
    if(top[a0] < 0)
        v0 = 0;
    else
        v0 = 1;
}
void place(){
    //a0 - color
    //a1 - column
    board[top[a1]] = a0;
    top[a1] -= 7;
}
void algorithm(){
    //no arguments
    while(1){
        t0 = rand() % 7;
        canPlace(t0);
        if(v0 == 1)
            goto _algorithm_exit;
    }
    _algorithm_exit:
    a0 = 1;
    a1 = t0;
    place();
    printf("\nComputerMove\n");
}
void printBoard(){
    for(int i = 0; i < 6; i++){
        for(int j = 0; j < 7; j++){
            printf("%3d", board[i * 7 + j]);
        }
        printf("\n");
    }
}
// void checkerHelper(){
//     if(t7 == -4)
//         goto _checker_end;
//     if(t7 == 4)
//         goto _checker_end;
// }
