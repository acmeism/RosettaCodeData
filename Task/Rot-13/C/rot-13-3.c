#include <stdio.h>
#include <ctype.h>

char rot13_char(char s);

int main(int argc, char *argv[]) {
    int c;
    if (argc != 1) {
        fprintf(stderr, "Usage: %s\n", argv[0]);
        return 1;
    }
    while((c = getchar()) != EOF) {
        putchar(rot13_char(c));
    }

    return 0;
}

char rot13_char(char c) {
    if (isalpha(c)) {
        char alpha = islower(c) ? 'a' : 'A';
        return (c - alpha + 13) % 26 + alpha;
    }
    return c;
}
