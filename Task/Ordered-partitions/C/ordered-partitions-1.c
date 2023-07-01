#include <stdio.h>

int next_perm(int size, int * nums)
{
        int *l, *k, tmp;

        for (k = nums + size - 2; k >= nums && k[0] >= k[1]; k--) {};
        if (k < nums) return 0;

        for (l = nums + size - 1; *l <= *k; l--) {};
        tmp = *k; *k = *l; *l = tmp;

        for (l = nums + size - 1, k++; k < l; k++, l--) {
                tmp = *k; *k = *l; *l = tmp;
        }

        return 1;
}

void make_part(int n, int * sizes)
{
        int x[1024], i, j, *ptr, len = 0;

        for (ptr = x, i = 0; i < n; i++)
                for (j = 0, len += sizes[i]; j < sizes[i]; j++, *(ptr++) = i);

        do {
                for (i = 0; i < n; i++) {
                        printf(" { ");
                        for (j = 0; j < len; j++)
                                if (x[j] == i) printf("%d ", j);

                        printf("}");
                }
                printf("\n");
        } while (next_perm(len, x));
}

int main()
{
        int s1[] = {2, 0, 2};
        int s2[] = {1, 2, 3, 4};

        printf("Part 2 0 2:\n");
        make_part(3, s1);

        printf("\nPart 1 2 3 4:\n");
        make_part(4, s2);

        return 1;
}
