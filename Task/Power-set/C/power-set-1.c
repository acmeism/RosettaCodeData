#include <limits.h>
#include <stdio.h>
#include <stdlib.h>

static void powerset(int argc, char** argv)
{
    unsigned int i, j, bits, i_max = 1U << argc;

    if (argc >= sizeof(i) * CHAR_BIT) {
        fprintf(stderr, "Error: set too large\n");
        exit(1);
    }

    for (i = 0; i < i_max ; ++i) {
        printf("{");
        for (bits = i, j = 0; bits; bits >>= 1, ++j) {
            if (bits & 1)
                printf(bits > 1 ? "%s, " : "%s", argv[j]);
        }
        printf("}\n");
    }
}

int main(int argc, char* argv[])
{
    powerset(argc - 1, argv + 1);
    return 0;
}
