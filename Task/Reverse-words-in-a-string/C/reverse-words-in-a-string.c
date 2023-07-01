#include <stdio.h>
#include <ctype.h>

void rev_print(char *s, int n)
{
        for (; *s && isspace(*s); s++);
        if (*s) {
                char *e;
                for (e = s; *e && !isspace(*e); e++);
                rev_print(e, 0);
                printf("%.*s%s", (int)(e - s), s, " " + n);
        }
        if (n) putchar('\n');
}

int main(void)
{
        char *s[] = {
                "---------- Ice and Fire ------------",
                "                                    ",
                "fire, in end will world the say Some",
                "ice. in say Some                    ",
                "desire of tasted I've what From     ",
                "fire. favor who those with hold I   ",
                "                                    ",
                "... elided paragraph last ...       ",
                "                                    ",
                "Frost Robert -----------------------",
                0
        };
        int i;
        for (i = 0; s[i]; i++) rev_print(s[i], 1);

        return 0;
}
