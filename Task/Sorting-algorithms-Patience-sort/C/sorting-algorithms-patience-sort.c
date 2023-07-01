#include<stdlib.h>
#include<stdio.h>

int* patienceSort(int* arr,int size){
	int decks[size][size],i,j,min,pickedRow;
	
	int *count = (int*)calloc(sizeof(int),size),*sortedArr = (int*)malloc(size*sizeof(int));
	
	for(i=0;i<size;i++){
		for(j=0;j<size;j++){
			if(count[j]==0 || (count[j]>0 && decks[j][count[j]-1]>=arr[i])){
				decks[j][count[j]] = arr[i];
				count[j]++;
				break;
			}
		}
	}
	
	min = decks[0][count[0]-1];
	pickedRow = 0;
	
	for(i=0;i<size;i++){
		for(j=0;j<size;j++){
			if(count[j]>0 && decks[j][count[j]-1]<min){
				min = decks[j][count[j]-1];
				pickedRow = j;
			}
		}
		sortedArr[i] = min;
		count[pickedRow]--;
		
		for(j=0;j<size;j++)
			if(count[j]>0){
				min = decks[j][count[j]-1];
				pickedRow = j;
				break;
			}
	}
	
	free(count);
	free(decks);
	
	return sortedArr;
}

int main(int argC,char* argV[])
{
	int *arr, *sortedArr, i;
	
	if(argC==0)
		printf("Usage : %s <integers to be sorted separated by space>");
	else{
		arr = (int*)malloc((argC-1)*sizeof(int));
		
		for(i=1;i<=argC;i++)
			arr[i-1] = atoi(argV[i]);
		
		sortedArr = patienceSort(arr,argC-1);
		
		for(i=0;i<argC-1;i++)
			printf("%d ",sortedArr[i]);
	}
	
	return 0;
}
