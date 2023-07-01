#include <stdio.h>
#include <ctype.h>

static int
owp(int odd)
{
        int ch, ret;
        ch = getc(stdin);
        if (!odd) {
                putc(ch, stdout);
                if (ch == EOF || ch == '.')
                        return EOF;
                if (ispunct(ch))
                        return 0;
                owp(odd);
                return 0;
        } else {
                if (ispunct(ch))
                        return ch;
                ret = owp(odd);
                putc(ch, stdout);
                return ret;
        }
}

int
main(int argc, char **argv)
{
        int ch = 1;
        while ((ch = owp(!ch)) != EOF) {
                if (ch)
                        putc(ch, stdout);
                if (ch == '.')
                        break;
        }
        return 0;
}
