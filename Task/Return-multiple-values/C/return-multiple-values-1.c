#include<stdio.h>

typedef struct{
	int integer;
	float decimal;
	char letter;
	char string[100];
	double bigDecimal;
}Composite;

Composite example()
{
	Composite C = {1, 2.3, 'a', "Hello World", 45.678};
	return C;
}


int main()
{
	Composite C = example();

	printf("Values from a function returning a structure : { %d, %f, %c, %s, %f}\n", C.integer, C.decimal, C.letter, C.string, C.bigDecimal);

	return 0;
}
