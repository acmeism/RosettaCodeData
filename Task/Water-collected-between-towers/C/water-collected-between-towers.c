#include<stdlib.h>
#include<stdio.h>

int getWater(int* arr,int start,int end,int cutoff){
	int i, sum = 0;
	
	for(i=start;i<=end;i++)
		sum += ((arr[cutoff] > arr[i])?(arr[cutoff] - arr[i]):0);
	
	return sum;
}

int netWater(int* arr,int size){
	int i, j, ref1, ref2, marker, markerSet = 0,sum = 0;
	
	if(size<3)
		return 0;

	for(i=0;i<size-1;i++){
		start:if(i!=size-2 && arr[i]>arr[i+1]){
				ref1 = i;
				
				for(j=ref1+1;j<size;j++){
					if(arr[j]>=arr[ref1]){
						ref2 = j;
						
						sum += getWater(arr,ref1+1,ref2-1,ref1);

						i = ref2;
						
						goto start;
					}
					
					else if(j!=size-1 && arr[j] < arr[j+1] && (markerSet==0||(arr[j+1]>=arr[marker]))){
						marker = j+1;
						markerSet = 1;
					}
				}
				
				if(markerSet==1){
					sum += getWater(arr,ref1+1,marker-1,marker);

					i = marker;
					
					markerSet = 0;
					
					goto start;
				}
			}
		}
	
	return sum;
}

int main(int argC,char* argV[])
{
	int *arr,i;
	
	if(argC==1)
		printf("Usage : %s <followed by space separated series of integers>");
	else{
		arr = (int*)malloc((argC-1)*sizeof(int));
		
		for(i=1;i<argC;i++)
			arr[i-1] = atoi(argV[i]);

		printf("Water collected : %d",netWater(arr,argC-1));
	}
	
	return 0;
}
