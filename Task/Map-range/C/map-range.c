#include <stdio.h>

#define mapRange(a1,a2,b1,b2,s) (b1 + (s-a1)*(b2-b1)/(a2-a1))

int main()
{
	int i;
	puts("Mapping [0,10] to [-1,0] at intervals of 1:");
	
	for(i=0;i<=10;i++)
	{
		printf("f(%d) = %g\n",i,mapRange(0,10,-1,0,i));
	}
	
	return 0;
}
