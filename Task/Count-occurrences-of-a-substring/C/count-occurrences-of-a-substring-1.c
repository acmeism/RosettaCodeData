#include <stdio.h>
#include <string.h>

int match(const char *s, const char *p, int overlap)
{
        int c = 0, l = strlen(p);

        while (*s != '\0') {
                if (strncmp(s++, p, l)) continue;
                if (!overlap) s += l - 1;
                c++;
        }
        return c;
}

int main()
{
        printf("%d\n", match("the three truths", "th", 0));
        printf("overlap:%d\n", match("abababababa", "aba", 1));
        printf("not:    %d\n", match("abababababa", "aba", 0));
        return 0;
}
