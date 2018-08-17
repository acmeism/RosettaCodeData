#include<stdlib.h>
#include<stdio.h>

int main(int argC,char* argV[])
{
	char str[1000];
	
	if(argC!=5)
		printf("Usage : %s < Followed by level, id, source string and description>",argV[0]);
	else{
		sprintf(str,"EventCreate /t %s /id %s /l APPLICATION /so %s /d \"%s\"",argV[1],argV[2],argV[3],argV[4]);
		system(str);
	}
	
	return 0;
}
