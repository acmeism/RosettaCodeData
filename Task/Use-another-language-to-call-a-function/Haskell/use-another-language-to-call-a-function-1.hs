#ifdef __GLASGOW_HASKELL__
#include "Called_stub.h"
extern void __stginit_Called(void);
#endif
#include <stdio.h>
#include <HsFFI.h>

int main (int argc, char * argv [])
{
    char     Buffer [1024];
    size_t   Size = sizeof (Buffer);

    hs_init(&argc, &argv);
#ifdef __GLASGOW_HASKELL__
    hs_add_root(__stginit_Called);
#endif

    if (0 == query_hs (Buffer, &Size))
        {
            printf ("failed to call Query\n");
        }
    else
        {
            char * Ptr = Buffer;
            while (Size-- > 0) putchar (*Ptr++);
            putchar ('\n');
        }

    hs_exit();
    return 0;
}
