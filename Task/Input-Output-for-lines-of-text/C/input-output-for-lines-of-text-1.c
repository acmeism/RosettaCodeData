#include<stdlib.h>
#include<stdio.h>

#define LEN 100 /* Max string length */

int main()
{
	char **list;
	int num, i;
	
	scanf("%d",&num);
	
	list = (char**)malloc(num*sizeof(char*));
	
	for(i=0;i<num;i++)
	{
	   list[i] = (char*)malloc(LEN*sizeof(char));
	   fflush(stdin);
	   fgets(list[i],LEN,stdin);
	}
	
	printf("\n");
	
	for(i=0;i<num;i++)
	{
		printf("%s",list[i]);
	}
	
	return 0;
}
