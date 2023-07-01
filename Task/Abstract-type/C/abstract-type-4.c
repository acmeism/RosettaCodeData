#include <stdio.h>
#include "silly.h"

int main()
{
    AbsCls abster = Silly_Instance(NewSilly( 10.1, "Green Tomato"));

    printf("AbsMethod1: %d\n", Abs_Method1(abster, 5));
    printf("AbsMethod2: %s\n", Abs_Method2(abster, 4));
    Abs_Method3(abster, 21.55);
    Abs_Free(abster);
    return 0;
}
