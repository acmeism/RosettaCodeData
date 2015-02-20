#include <stdio.h>
#include <stdlib.h>

unsigned long long sum35(unsigned long long limit)
{
    unsigned long long sum = 0;
    for (unsigned long long i = 0; i < limit; i++)
        if (!(i % 3) || !(i % 5))
            sum += i;
    return sum;
}

int main(int argc, char **argv)
{
    unsigned long long limit;

    if (argc == 2)
        limit = strtoull(argv[1], NULL, 10);
    else
        limit = 1000;

    printf("%lld\n", sum35(limit));
    return 0;
}
