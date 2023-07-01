#include <stdio.h>

typedef int (*intFn)(int, int);

int reduce(intFn fn, int size, int *elms)
{
    int i, val = *elms;
    for (i = 1; i < size; ++i)
        val = fn(val, elms[i]);
    return val;
}

int add(int a, int b) { return a + b; }
int sub(int a, int b) { return a - b; }
int mul(int a, int b) { return a * b; }

int main(void)
{
    int nums[] = {1, 2, 3, 4, 5};
    printf("%d\n", reduce(add, 5, nums));
    printf("%d\n", reduce(sub, 5, nums));
    printf("%d\n", reduce(mul, 5, nums));
    return 0;
}
