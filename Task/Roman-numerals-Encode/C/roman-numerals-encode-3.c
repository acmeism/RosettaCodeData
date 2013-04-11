#include <stdio.h>

int to_roman(char *out, int n)
{
        int len = 0;
        if (n <= 0) return 0; /* error indication */
#       define RPUT(c) if (out) out[len] = c; len++
        while(n>= 1000) { n -= 1000;RPUT('M'); };

        if (n >= 900)   { n -= 900; RPUT('C'); RPUT('M'); };
        if (n >= 500)   { n -= 500; RPUT('D'); };
        if (n >= 400)   { n -= 400; RPUT('C'); RPUT('D'); };
        while (n >= 100){ n -= 100; RPUT('C'); };

        if (n >= 90)    { n -= 90;  RPUT('X'); RPUT('C'); };
        if (n >= 50)    { n -= 50;  RPUT('L'); };
        if (n >= 40)    { n -= 40;  RPUT('X'); RPUT('L'); };
        while (n >= 10) { n -= 10;  RPUT('X'); };

        if (n >= 9)     { n -= 9;   RPUT('I'); RPUT('X'); };
        if (n >= 5)     { n -= 5;   RPUT('V'); };
        if (n >= 4)     { n -= 4;   RPUT('I'); RPUT('V'); };
        while (n)       { n--; RPUT('I'); };
        RPUT('\0');
#       undef RPUT

        return len;
}

int main()
{
        char buf[16];
        int d = to_roman(buf, 1666);
        printf("roman for 1666 is %d bytes: %s\n", d, buf);

        d = 68999123;
        printf("%d would have required %d bytes\n", d, to_roman(0, d));

        return 0;
}
