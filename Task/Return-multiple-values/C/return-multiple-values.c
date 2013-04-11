#include<stdio.h>

typedef struct{
	int integer;
	float decimal;
	char letter;
	char string[100];
	double bigDecimal;
}Composite;
	
typedef union{
	int num;
	char letter;
}Zip;

Composite example()
{
	Composite C = {1,2.3,'a',"Hello World",45.678};
	return C;
}

Zip example2()
{
	Zip r;
	r.num = 99;
	r.letter = 'C';
	return r;
}

int main()
{
	Composite C = example();
	Zip rar = example2();
	
	printf("Values from a function returning a structure : { %d, %f, %c, %s, %f}",C.integer, C.decimal,C.letter,C.string,C.bigDecimal);
	printf("\n\nValues from a function returning a union : { %d, %c}",rar.num,rar.letter);
	
	return 0;
}
