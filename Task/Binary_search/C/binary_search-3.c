#include <stdlib.h> /* for bsearch */
#include <stdio.h>

int intcmp(const void *a, const void *b)
{
    /* this is only correct if it doesn't overflow */
    return *(const int *)a - *(const int *)b;
}

int main()
{
    int nums[5] = {2, 3, 5, 6, 8};
    int desired = 6;
    int *ptr = bsearch(&desired, nums, 5, sizeof(int), intcmp);
    if (ptr == NULL)
        printf("not found\n");
    else
        printf("index = %d\n", ptr - nums);

    return 0;
}
