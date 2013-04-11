#include <stdio.h>
int main(int argc, char* argv[])
{
        int input;
        if((scanf("%d", &input))==1)
        {
                printf("Read in %d\n", input);
                return 1;
        }
        return 0;
}
