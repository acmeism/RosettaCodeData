#include<stdarg.h>
#include<stdio.h>

long int factorial(int n){
	if(n>1)
		return n*factorial(n-1);
	return 1;
}

long int sumOfFactorials(int num,...){
	va_list vaList;
	long int sum = 0;
	
	va_start(vaList,num);
	
	while(num--)
		sum += factorial(va_arg(vaList,int));
	
	va_end(vaList);
	
	return sum;
}

int main()
{
	printf("\nSum of factorials of [1,5] : %ld",sumOfFactorials(5,1,2,3,4,5));
	printf("\nSum of factorials of [3,5] : %ld",sumOfFactorials(3,3,4,5));
	printf("\nSum of factorials of [1,3] : %ld",sumOfFactorials(3,1,2,3));
	
	return 0;
}
