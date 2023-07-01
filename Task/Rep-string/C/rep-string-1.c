#include <stdio.h>
#include <string.h>

int repstr(char *str)
{
    if (!str) return 0;

    size_t sl = strlen(str) / 2;
    while (sl > 0) {
        if (strstr(str, str + sl) == str)
            return sl;
        --sl;
    }

    return 0;
}

int main(void)
{
    char *strs[] = { "1001110011", "1110111011", "0010010010", "1111111111",
        "0100101101", "0100100", "101", "11", "00", "1" };

    size_t strslen = sizeof(strs) / sizeof(strs[0]);
    size_t i;
    for (i = 0; i < strslen; ++i) {
        int n = repstr(strs[i]);
        if (n)
            printf("\"%s\" = rep-string \"%.*s\"\n", strs[i], n, strs[i]);
        else
            printf("\"%s\" = not a rep-string\n", strs[i]);
    }

    return 0;
}
