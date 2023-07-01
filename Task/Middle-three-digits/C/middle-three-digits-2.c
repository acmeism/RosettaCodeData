#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void midThree(char arg[])
{
    char output[4];
    int midPoint;
    arg[0]=='-'?midPoint = ((strlen(arg) + 1) / 2):midPoint = ((strlen(arg) + 1) / 2) - 1;

    if(strlen(arg) < 3)
        {
            printf("Error, %d is too short.\n",atoi(arg));
            return ;
        }
        else if(strlen(arg)  == 4 || strlen(arg) == 3)
        {
            printf("Error, %d has %d digits, no 3 middle digits.\n",atoi(arg),arg[0]=='-'?strlen(arg)-1:strlen(arg));
            return ;
        }
    else{
    for(int i=0; i<3; i++)
    {
        output[i] = arg[(midPoint-1) + i];
    }
    output[3] = '\0';
    printf("The middle three digits of %s are %s.\n",arg,output);
}}

int main(int argc, char * argv[])
{
    char input[50];
    int x[] = {123, 12345, 1234567, 987654321, 10001, -10001,
		-123, -100, 100, -12345, 1, 2, -1, -10, 2002, -2002, 0,
		1234567890},i;
		
    if(argc < 2)
    {
        printf("Usage: %s <integer>\n",argv[0]);
        printf("Examples with preloaded data shown below :\n");

        for(i=0;i<18;i++)
        {
	        midThree(itoa(x[i],argv[0],10));
	     }
        return 1;
    }
    else
    {
        sprintf(input,"%d",atoi(argv[1]));
            midThree(argv[1]);
            return 0;


    }
}
