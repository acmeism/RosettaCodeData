#include <stdio.h> // Standard IO
#include <stdlib.h> // other stuff
#include <time.h>
#include <string.h>

//This should add weighted random function to "The Elite Noob"'s code, stolen from above code because it does calculation so well
//closest I could make it to original but without pointless attempt to make code look smaller than above code by putting code on the same lines

int rand_i(int n)
{
	int rand_max = RAND_MAX - (RAND_MAX % n);
	int ret;
	while ((ret = rand()) >= rand_max);
	return ret/(rand_max / n);
}

int weighed_rand(int *tbl, int len)
{
	int i, sum, r;
	for (i = 0, sum = 0; i < len; sum += tbl[i++]);
	if (!sum) return rand_i(len);

	r = rand_i(sum) + 1;
	for (i = 0; i < len && (r -= tbl[i]) > 0; i++);
	return i;
}



int main(int argc, const char *argv[])
{
	char umove[10], cmove[10], line[255];
	int user, comp;
	int tbl[]={0,0,0};
	int tbllen=3;
	printf("Hello, Welcome to rock-paper-scissors\nBy The Elite Noob\n");
mainloop:
	while(1)
	{ // infinite loop :)
		printf("\n\nPlease type in 1 for Rock, 2 For Paper, 3 for Scissors, 4 to quit\n");
		srand(time(NULL));
		comp = (weighed_rand(tbl, tbllen) + 1) % 3;
		fgets(line, sizeof(line), stdin);	
		while(sscanf(line, "%d", &user) != 1) //1 match of defined specifier on input line
		{
  			printf("You have not entered an integer.\n");
			fgets(line, sizeof(line), stdin);
		}				
		if( (user > 4) || (user < 1) )
		{
			printf("Please enter a valid number!\n");
			continue;
		}
		switch (comp)
		{
			case 1 :
				strcpy(cmove, "Rock");
				break;
			case 2 :
				strcpy(cmove, "Paper");
				break;
			case 3 :
				strcpy(cmove, "Scissors");
				break;
			default :
				printf("Computer Error, set comp=1\n");
				comp=1;
				strcpy(cmove, "Rock");
				break;
		}
		switch (user)
		{
			case 1 :
				strcpy(umove, "Rock");
				break;
			case 2 :
				strcpy(umove, "Paper");
				break;
			case 3 :
				strcpy(umove, "Scissors");
				break;
			case 4 :
				printf("Goodbye! Thanks for playing!\n");
				return 0;
			default :
				printf("Error, user number not between 1-4 exiting...");
				goto mainloop;
		}
		if( (user+1)%3 == comp )
		{
			printf("Comp Played: %s\nYou Played: %s\nSorry, You Lost!\n", cmove, umove);
		}	
		else if(comp == user)
		{
			printf("Comp Played: %s\nYou Played: %s\nYou Tied :p\n", cmove, umove);
		}
		else
		{
			printf("Comp Played: %s\nYou Played: %s\nYay, You Won!\n", cmove, umove);
		}
		tbl[user-1]++;
	}
}
