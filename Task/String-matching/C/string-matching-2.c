#include <stdio.h>

/* returns 0 if no match, 1 if matched, -1 if matched and at end */
int s_cmp(const char *a, const char *b)
{
        char c1 = 0, c2 = 0;
        while (c1 == c2) {
                c1 = *(a++);
                if ('\0' == (c2 = *(b++)))
                        return c1 == '\0' ? -1 : 1;
        }
        return 0;
}

/* returns times matched */
int s_match(const char *a, const char *b)
{
        int i = 0, count = 0;
        printf("matching `%s' with `%s':\n", a, b);

        while (a[i] != '\0') {
                switch (s_cmp(a + i, b)) {
                case -1:
                        printf("matched: pos %d (at end)\n\n", i);
                        return ++count;
                case 1:
                        printf("matched: pos %d\n", i);
                        ++count;
                        break;
                }
                i++;
        }
        printf("end match\n\n");
        return count;
}

int main()
{
        s_match("A Short String", "ort S");
        s_match("aBaBaBaBa", "aBa");
        s_match("something random", "Rand");

        return 0;
}
