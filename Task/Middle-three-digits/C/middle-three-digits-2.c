#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char input[50];
int midPoint;

void midThree(char arg[])
{
    char output[4];
    for(int i=0; i<3; i++)
    {
        output[i] = input[(midPoint-1) + i];
    }
    output[3] = '\0';
    printf("The middle three digits of %s are %s.\n",arg,output);
}

int main(int argc, char * argv[])
{
    if(argc < 2)
    {
        printf("Usage: %s <integer>\n",argv[0]);
        return 1;
    }
    else
    {
        sprintf(input,"%d",abs(atoi(argv[1])));
        if(strlen(input) < 3)
        {
            printf("Error, %d is too short.\n",atoi(argv[1]));
            return 1;
        }
        else if(strlen(input) % 2 == 0)
        {
            printf("Error, %d is even.\n",atoi(argv[1]));
            return 1;
        }
        else
        {
            midPoint = ((strlen(input) + 1) / 2) - 1;
            midThree(argv[1]);
            return 0;
        }

    }
}
