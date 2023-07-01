#include <stdio.h>
#include <stdlib.h>
#define otherwise       do { register int _o = 2; do { switch (_o) {  case 1:
#define given(Mc)       ;case 0: break; case 2: _o = !!(Mc); continue; } break; } while (1); } while (0)


int foo() { return 1; }

main()
{
        int a = 0;

        otherwise  a = 4 given (foo());
        printf("%d\n", a);
        exit(0);
}
