#include <stdio.h>

int main(void)
{
    for (int i = 1; i <= 100; ++i) {
        if (i % 3 == 0) printf("fizz");
        if (i % 5 == 0) printf("buzz");
        if (i * i * i * i % 15 == 1) printf("%d", i);
        puts("");
    }
}
