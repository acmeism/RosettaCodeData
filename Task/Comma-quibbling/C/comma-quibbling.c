#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char *quib(const char **strs, size_t size)
{

    size_t len = 3 + ((size > 1) ? (2 * size + 1) : 0);
    size_t i;

    for (i = 0; i < size; i++)
        len += strlen(strs[i]);

    char *s = malloc(len * sizeof(*s));
    if (!s)
    {
        perror("Can't allocate memory!\n");
        exit(EXIT_FAILURE);
    }

    strcpy(s, "{");
    switch (size) {
        case 0:  break;
        case 1:  strcat(s, strs[0]);
                 break;
        default: for (i = 0; i < size - 1; i++)
                 {
                     strcat(s, strs[i]);
                     if (i < size - 2)
                         strcat(s, ", ");
                     else
                         strcat(s, " and ");
                 }
                 strcat(s, strs[i]);
                 break;
    }
    strcat(s, "}");
    return s;
}

int main(void)
{
    const char *test[] = {"ABC", "DEF", "G", "H"};
    char *s;

    for (size_t i = 0; i < 5; i++)
    {
        s = quib(test, i);
        printf("%s\n", s);
        free(s);
    }
    return EXIT_SUCCESS;
}
