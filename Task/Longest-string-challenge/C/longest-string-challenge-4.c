#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int longer(const char *p, const char *q) {
        while (*p && *q) p = &p[1], q = &q[1];
        return *p;
}

int main() {
        char line[100000];
        char buf[1100001];
        char *linend= &line[99999];
        char *bufend= &buf[1000000];
        char *last = buf;
        char *next = buf;

        memset(line, 1, 100000);
        memset(buf, 1, 1100001);
        buf[0]= buf[1100000]= 0;
        while (fgets(line, 100000, stdin)) {
                if (!*linend) exit(1);
                if (longer(last, line)) continue;
                if (!longer(bufend, line)) exit(1);
                if (longer(line, last)) next = buf;
                last = next;
                strcpy(next, line);
                while (*next) next = &next[1];
        }

        printf("%s", buf);
        exit(0);
}
