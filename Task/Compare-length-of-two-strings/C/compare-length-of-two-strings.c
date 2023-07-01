#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int cmp(const int* a, const int* b)
{
    return *b - *a; // reverse sort!
}

void compareAndReportStringsLength(const char* strings[], const int n)
{
    if (n > 0)
    {
        char* has_length = "has length";
        char* predicate_max = "and is the longest string";
        char* predicate_min = "and is the shortest string";
        char* predicate_ave = "and is neither the longest nor the shortest string";

        int* si = malloc(2 * n * sizeof(int));
        if (si != NULL)
        {
            for (int i = 0; i < n; i++)
            {
                si[2 * i] = strlen(strings[i]);
                si[2 * i + 1] = i;
            }
            qsort(si, n, 2 * sizeof(int), cmp);

            int max = si[0];
            int min = si[2 * (n - 1)];

            for (int i = 0; i < n; i++)
            {
                int length = si[2 * i];
                char* string = strings[si[2 * i + 1]];
                char* predicate;
                if (length == max)
                    predicate = predicate_max;
                else if (length == min)
                    predicate = predicate_min;
                else
                    predicate = predicate_ave;
                printf("\"%s\" %s %d %s\n",
                    string, has_length, length, predicate);
            }

            free(si);
        }
        else
        {
            fputs("unable allocate memory buffer", stderr);
        }
    }
}

int main(int argc, char* argv[])
{
    char* list[] = { "abcd", "123456789", "abcdef", "1234567" };

    compareAndReportStringsLength(list, 4);

    return EXIT_SUCCESS;
}
