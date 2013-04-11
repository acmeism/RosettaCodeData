#include <stdio.h> // Standard IO
#include <stdlib.h> // other stuff
#include <time.h>
#include <string.h>
int main(int argc, const char *argv[]){
	printf("Hello, Welcome to rock-paper-scissors\nBy The Elite Noob\n");
	while(1){ // infinite loop :)
		printf("\n\nPlease type in 1 for Rock, 2 For Paper, 3 for Scissors, 4 to quit\n");
		srand(time(NULL));
		int user, comp = (rand()%3)+1;
		char line[255];
		fgets(line, sizeof(line), stdin);	
		while(sscanf(line, "%d", &user) != 1) { //1 match of defined specifier on input line
  			printf("You have not entered an integer.\n");
			fgets(line, sizeof(line), stdin);
		}				
		if(user != 1 && user != 2 && user != 3  && user != 4){printf("Please enter a valid number!\n");continue;}
		char umove[10], cmove[10];
		if(comp == 1){strcpy(cmove, "Rock");}else if(comp == 2){strcpy(cmove, "Paper");}else{strcpy(cmove, "Scissors");}
		if(user == 1){strcpy(umove, "Rock");}else if(user == 2){strcpy(umove, "Paper");}else{strcpy(umove, "Scissors");}	
		if(user == 4){printf("Goodbye! Thanks for playing!\n");break;}
		if((comp == 1 && user == 3)||(comp == 2 && user == 1)||(comp == 3 && user == 2)){
			printf("Comp Played: %s\nYou Played: %s\nSorry, You Lost!\n", cmove, umove);
		}else if(comp == user){
				printf("Comp Played: %s\nYou Played: %s\nYou Tied :p\n", cmove, umove);}
		else{
			printf("Comp Played: %s\nYou Played: %s\nYay, You Won!\n", cmove, umove);
	}}return 1;}
