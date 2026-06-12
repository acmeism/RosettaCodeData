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

int main()
{
	int i;
	
	int a[] = {};
	int b[] = {10};
	int c[] = {10, 20};
	int d[] = {10, 20, 30};
	int e[] = {11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22};

	srand((unsigned)time(NULL));
	sattoloCycle((void*)a,0);
		
	printf("\nShuffled a = ");
	for(i=0;i<0;i++)
		printf("%d ",a[i]);
		
	sattoloCycle((void*)b,1);
		
	printf("\nShuffled b = ");
	for(i=0;i<1;i++)
		printf("%d ",b[i]);
			
	sattoloCycle((void*)c,2);
		
	printf("\nShuffled c = ");
	for(i=0;i<2;i++)
		printf("%d ",c[i]);
	
	sattoloCycle((void*)d,3);
		
	printf("\nShuffled d = ");
	for(i=0;i<3;i++)
		printf("%d ",d[i]);
		
	sattoloCycle((void*)e,12);
		
	printf("\nShuffled e = ");
	for(i=0;i<12;i++)
		printf("%d ",e[i]);

	return 0;
}
