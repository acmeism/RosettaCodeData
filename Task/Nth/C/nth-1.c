#include <stdio.h>

char* addSuffix(int num, char* buf, size_t len)
{
    char *suffixes[4] = { "th", "st", "nd", "rd" };
    int i;

    switch (num % 10)
    {
        case 1 : i = (num % 100 == 11) ? 0 : 1;
	         break;
        case 2 : i = (num % 100 == 12) ? 0 : 2;
                 break;
        case 3 : i = (num % 100 == 13) ? 0 : 3;
                 break;
        default: i = 0;
    };

    snprintf(buf, len, "%d%s", num, suffixes[i]);
    return buf;
}

int main(void)
{
    int i;

    printf("Set [0,25]:\n");
    for (i = 0; i < 26; i++)
    {
        char s[5];
        printf("%s ", addSuffix(i, s, 5));
    }
    putchar('\n');

    printf("Set [250,265]:\n");
    for (i = 250; i < 266; i++)
    {
        char s[6];
        printf("%s ", addSuffix(i, s, 6));
    }
    putchar('\n');

    printf("Set [1000,1025]:\n");
    for (i = 1000; i < 1026; i++)
    {
        char s[7];
        printf("%s ", addSuffix(i, s, 7));
    }
    putchar('\n');

    return 0;
}
