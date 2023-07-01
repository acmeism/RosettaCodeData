#include<stdio.h>
#define de 0
#define pe 1
#define ab 2

int main(){
	int sum = 0, i, j;
	int try_max = 0;
	//1 is deficient by default and can add it deficient list
	int   count_list[3] = {1,0,0};
	for(i=2; i <= 20000; i++){
		//Set maximum to check for proper division
		try_max = i/2;
		//1 is in all proper division number
		sum = 1;
		for(j=2; j<try_max; j++){
			//Check for proper division
			if (i % j)
				continue; //Pass if not proper division
			//Set new maximum for divisibility check
			try_max = i/j;
			//Add j to sum
			sum += j;
			if (j != try_max)
				sum += try_max;
		}
		//Categorize summation
		if (sum < i){
			count_list[de]++;
			continue;
		}
		if (sum > i){
			count_list[ab]++;
			continue;
		}
		count_list[pe]++;
	}
	printf("\nThere are %d deficient," ,count_list[de]);
	printf(" %d perfect," ,count_list[pe]);
	printf(" %d abundant numbers between 1 and 20000.\n" ,count_list[ab]);
return 0;
}
