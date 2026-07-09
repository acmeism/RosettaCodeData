#include <stdio.h>
#define RDRANDMAX 0x7fffffff
int rdrand() {
    asm("69:    rdrand %eax\n"
        "       jnc 69b\n"
        "       shr $1, %eax\n");
    }

int main() {
    printf("%i\n", rdrand());
    return (0);
    }
