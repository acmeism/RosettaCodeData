#include <stdio.h>
#include <stdlib.h>
#include "libQuery_api.h"

static int Query (char * Data, size_t * Length)
{
    return libQuery_symbols() -> kotlin.root.query(Data, Length);
}

int main (int argc, char * argv [])
{
    char     Buffer [1024];
    size_t   Size = sizeof (Buffer);

    if (0 == Query (Buffer, &Size))
    {
        printf ("failed to call Query\n");
    }
    else
    {
        char * Ptr = Buffer;
        while (Size-- > 0) putchar (*Ptr++);
        putchar ('\n');
    }
}
