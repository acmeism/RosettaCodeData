#include <stdio.h>
#include <stdlib.h>
#include <string.h>
char *split(char *str);
int main(int argc,char **argv)
{
	char input[13]="gHHH5YY++///\\";
	printf("%s\n",split(input));
}
char *split(char *str)
{
	char last=*str,*result=malloc(3*strlen(str)),*counter=result;
	for (char *c=str;*c;c++) {
		if (*c!=last) {
			strcpy(counter,", ");
			counter+=2;
			last=*c;
		}
		*counter=*c;
		counter++;
	}
	*(counter--)='\0';
	return realloc(result,strlen(result));
}
