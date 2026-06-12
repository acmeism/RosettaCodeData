#include<stdio.h>

int main()
{
	int arr[5] = {0, 2, 11, 19, 90},sum = 21,i,j,check = 0;
	
	for(i=0;i<4;i++){
		for(j=i+1;j<5;j++){
			if(arr[i]+arr[j]==sum){
				printf("[%d,%d]",i,j);
				check = 1;
				break;
			}
		}
	}
	
	if(check==0)
		printf("[]");
	
	return 0;
}
