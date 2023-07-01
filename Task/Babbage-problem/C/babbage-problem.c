// This code is the implementation of Babbage Problem

#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

int main() {
	int current = 0, 	//the current number
	    square;		//the square of the current number

	//the strategy of take the rest of division by 1e06 is
	//to take the a number how 6 last digits are 269696
	while (((square=current*current) % 1000000 != 269696) && (square<INT_MAX)) {
		current++;
	}

        //output
	if (square>+INT_MAX)
	    printf("Condition not satisfied before INT_MAX reached.");
	else		
	    printf ("The smallest number whose square ends in 269696 is %d\n", current);
	
        //the end
	return 0 ;
}
