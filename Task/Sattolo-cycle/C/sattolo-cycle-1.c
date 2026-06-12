#include<stdlib.h>
#include<stdio.h>
#include<time.h>

void sattoloCycle(void** arr,int count){
	int i,j;
	void* temp;
	
	if(count<2)
		return;
	for(i=count-1;i>=1;i--){
		j = rand()%i;
		temp = arr[j];
		arr[j] = arr[i];
		arr[i] = temp;
	}
}

int main(int argC,char* argV[])
{
	int i;
	
	if(argC==1)
		printf("Usage : %s <array elements separated by a space each>",argV[0]);
	else{
                srand((unsigned)time(NULL));
		sattoloCycle((void*)(argV + 1),argC-1);
		
		for(i=1;i<argC;i++)
			printf("%s ",argV[i]);
	}
	return 0;
}
