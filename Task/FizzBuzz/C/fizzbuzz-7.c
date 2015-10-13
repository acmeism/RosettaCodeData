#include <stdio.h>
int main()
{
    for (int i=0;++i<101;puts(""))
    {
        char f[] = "FizzBuzz%d";
        f[8-i%5&12]=0;
        printf (f+(-i%3&4+f[8]/8), i);
    }
}
