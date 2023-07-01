#include<stdio.h>

int isPrime(unsigned int n)
{
	unsigned int num;
	
	if ( n < 2||!(n & 1))
		return n == 2;

	for (num = 3; num <= n/num; num += 2)
		if (!(n % num))
			return 0;
	return 1;
}

int main()
{
	unsigned int l,u,i,sum=0;
	
	printf("Enter lower and upper bounds: ");
	scanf("%ld%ld",&l,&u);
	
	for(i=l;i<=u;i++){
		if(isPrime(i)==1)
			{
				printf("\n%ld",i);
				sum++;
			}
	}
	
	printf("\n\nPrime numbers found in [%ld,%ld] : %ld",l,u,sum);
	
	return 0;
}
