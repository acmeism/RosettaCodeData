#include<stdlib.h>
#include<string.h>
#include<stdio.h>

int flag = 1;

void heapPermute(int n, int arr[],int arrLen){
	int temp;
	int i;
	
	if(n==1){
		printf("\n[");
		
		for(i=0;i<arrLen;i++)
			printf("%d,",arr[i]);
		printf("\b] Sign : %d",flag);
		
		flag*=-1;
	}
	else{
		for(i=0;i<n-1;i++){
			heapPermute(n-1,arr,arrLen);
			
			if(n%2==0){
				temp = arr[i];
				arr[i] = arr[n-1];
				arr[n-1] = temp;
			}
			else{
				temp = arr[0];
				arr[0] = arr[n-1];
				arr[n-1] = temp;
			}
		}
		heapPermute(n-1,arr,arrLen);
	}
}

int main(int argC,char* argV[0])
{
	int *arr, i=0, count = 1;
	char* token;
	
	if(argC==1)
		printf("Usage : %s <comma separated list of integers>",argV[0]);
	else{
		while(argV[1][i]!=00){
			if(argV[1][i++]==',')
				count++;
		}
		
		arr = (int*)malloc(count*sizeof(int));
		
		i = 0;
		
		token = strtok(argV[1],",");
		
		while(token!=NULL){
			arr[i++] = atoi(token);
			token = strtok(NULL,",");
		}
		
		heapPermute(i,arr,count);
	}
		
	return 0;
}
