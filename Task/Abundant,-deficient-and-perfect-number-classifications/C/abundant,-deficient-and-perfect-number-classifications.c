#include<stdio.h>
#define d 0
#define p 1
#define a 2
int main(){
	int sum_pd=0,i,j;
	int try_max=0;
	//1 is deficient by default and can add it deficient list
	int   count_list[3]={1,0,0};
	for(i=2;i<=20000;i++){
		//Set maximum to check for proper division
		try_max=i/2;
		//1 is in all proper division number
		sum_pd=1;
		for(j=2;j<try_max;j++){
			//Check for proper division
			if (i%j)
				continue; //Pass if not proper division
			//Set new maximum for divisibility check
			try_max=i/j;
			//Add j to sum
			sum_pd+=j;
			if (j!=try_max)
				sum_pd+=try_max;
		}
		//Categorize summation
		if (sum_pd<i){
			count_list[d]++;
			continue;
		}
		else if (sum_pd>i){
			count_list[a]++;
			continue;
		}
		count_list[p]++;
	}
	printf("\nThere are %d deficient,",count_list[d]);
	printf(" %d perfect,",count_list[p]);
	printf(" %d abundant numbers between 1 and 20000.\n",count_list[a]);
return 0;
}
