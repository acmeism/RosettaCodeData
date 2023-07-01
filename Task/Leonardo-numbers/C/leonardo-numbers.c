#include<stdio.h>

void leonardo(int a,int b,int step,int num){
	
	int i,temp;
	
	printf("First 25 Leonardo numbers : \n");
	
	for(i=1;i<=num;i++){
		if(i==1)
			printf(" %d",a);
		else if(i==2)
			printf(" %d",b);
		else{
			printf(" %d",a+b+step);
			temp = a;
			a = b;
			b = temp+b+step;
		}
	}
}

int main()
{
	int a,b,step;
	
	printf("Enter first two Leonardo numbers and increment step : ");
	
	scanf("%d%d%d",&a,&b,&step);
	
	leonardo(a,b,step,25);
	
	return 0;
}
