#include<stdio.h>
#include<math.h>

int main()
{
    printf("(5 ^ 3) ^ 2 = %.0f",pow(pow(5,3),2));
    printf("\n5 ^ (3 ^ 2) = %.0f",pow(5,pow(3,2)));
	
    return 0;
}
