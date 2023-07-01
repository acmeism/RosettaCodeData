#include <stdio.h>
#include <stdlib.h>

struct replace_info {
    int n;
    char *text;
};

int compare(const void *a, const void *b)
{
    struct replace_info *x = (struct replace_info *) a;
    struct replace_info *y = (struct replace_info *) b;
    return x->n - y->n;
}

void generic_fizz_buzz(int max, struct replace_info *info, int info_length)
{
    int i, it;
    int found_word;

    for (i = 1; i < max; ++i) {
        found_word = 0;

        /* Assume sorted order of values in the info array */
        for (it = 0; it < info_length; ++it) {
            if (0 == i % info[it].n) {
                printf("%s", info[it].text);
                found_word = 1;
            }
        }

        if (0 == found_word)
            printf("%d", i);

        printf("\n");
    }
}

int main(void)
{
    struct replace_info info[3] = {
        {5, "Buzz"},
        {7, "Baxx"},
        {3, "Fizz"}
    };

    /* Sort information array */
    qsort(info, 3, sizeof(struct replace_info), compare);

    /* Print output for generic FizzBuzz */
    generic_fizz_buzz(20, info, 3);
    return 0;
}
