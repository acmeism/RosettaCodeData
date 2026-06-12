#define _XOPEN_SOURCE
#include <stdio.h>
#include <time.h>

int main() {
    struct tm t[2];
    strptime("2021-12-25", "%F", &t[0]);
    strptime("2022-01-01", "%F", &t[1]);
    for (int i=0; i<2; i++) {
        char buf[32];
        strftime(buf, 32, "%F is a %A", &t[i]);
        puts(buf);
    }
    return 0;
}
