#include <stdio.h>
#include <stdlib.h>
#include <math.h>

float *benford_distribution(void)
{
    static float prob[9];
    for (int i = 1; i < 10; i++)
        prob[i - 1] = log10f(1 + 1.0 / i);

    return prob;
}

float *get_actual_distribution(char *fn)
{
    FILE *input = fopen(fn, "r");
    if (!input)
    {
        perror("Can't open file");
        exit(EXIT_FAILURE);
    }

    int tally[9] = { 0 };
    char c;
    int total = 0;
    while ((c = getc(input)) != EOF)
    {
        /* get the first nonzero digit on the current line */
        while (c < '1' || c > '9')
            c = getc(input);

        tally[c - '1']++;
        total++;

        /* discard rest of line */
        while ((c = getc(input)) != '\n' && c != EOF)
            ;
    }
    fclose(input);

    static float freq[9];
    for (int i = 0; i < 9; i++)
        freq[i] = tally[i] / (float) total;

    return freq;
}

int main(int argc, char **argv)
{
    if (argc != 2)
    {
        printf("Usage: benford <file>\n");
        return EXIT_FAILURE;
    }

    float *actual = get_actual_distribution(argv[1]);
    float *expected = benford_distribution();

    puts("digit\tactual\texpected");
    for (int i = 0; i < 9; i++)
        printf("%d\t%.3f\t%.3f\n", i + 1, actual[i], expected[i]);

    return EXIT_SUCCESS;
}
