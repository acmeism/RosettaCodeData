//Evidence of the Monty Hall solution of marquinho1986 in C [github.com/marquinho1986]

#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <time.h>
#include <math.h>
#define NumSim 1000000000 // one billion of simulations! using the Law of large numbers concept [https://en.wikipedia.org/wiki/Law_of_large_numbers]

void main() {
      unsigned long int i,stay=0;
      int ChosenDoor,WinningDoor;
      bool door[3]={0,0,0};

      srand(time(NULL));  //initialize random seed.
	
	  for(i=0;i<=NumSim;i++){
	
	      WinningDoor=rand() % 3; // choosing winning door.
	
	      ChosenDoor=rand() % 3;  // selected door.
	
	      if(door[WinningDoor]=true,door[ChosenDoor])stay++;
	
	      door[WinningDoor]=false;
	
      }
	
     printf("\nAfter %lu games, I won %u by staying.  That is %f%%. and I won by switching %lu That is %f%%",NumSim, stay, (float)stay*100.0/(float)i,abs(NumSim-stay),100-(float)stay*100.0/(float)i);
	
  }
