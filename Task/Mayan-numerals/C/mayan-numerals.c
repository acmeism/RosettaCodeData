#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stdlib.h>

#define MAX(x,y) ((x) > (y) ? (x) : (y))
#define MIN(x,y) ((x) < (y) ? (x) : (y))

/* Find base-20 digits. */
size_t base20(unsigned int n, uint8_t *out) {
    /* generate digits */
    uint8_t *start = out;
    do {*out++ = n % 20;} while (n /= 20);
    size_t length = out - start;

    /* put digits in high-endian order */
    while (out > start) {
        uint8_t x = *--out;
        *out = *start;
        *start++ = x;
    }
    return length;
}

/* Write a Mayan digit */
void make_digit(int n, char *place, size_t line_length) {
    static const char *parts[] = {"    "," .  "," .. ","... ","....","----"};
    int i;

    /* write 4-part digit */
    for (i=4; i>0; i--, n -= 5)
        memcpy(place + i*line_length, parts[MAX(0, MIN(5, n))], 4);

    /* if digit was 0 we should put '@' in 2nd position of last line */
    if (n == -20) place[4 * line_length + 1] = '@';
}

/* Make a Mayan numeral */
char *mayan(unsigned int n) {
    if (n == 0) return NULL;

    uint8_t digits[15]; /* 2**64 is 15 Mayan digits long */
    size_t n_digits = base20(n, digits);

    /* a digit is 4 chars wide, plus N+1 divider lines, plus a newline
       makes for a length of 5*n+2 */
    size_t line_length = n_digits*5 + 2;

    /* we need 6 lines - four for the digits, plus top and bottom row */
    char *str = malloc(line_length * 6 + 1);
    if (str == NULL) return NULL;
    str[line_length * 6] = 0;

    /* make the cartouche divider lines */
    char *ptr;
    unsigned int i;
    /* top and bottom row */
    for (ptr=str, i=0; i<line_length; i+=5, ptr+=5)
        memcpy(ptr, "+----", 5);
    memcpy(ptr-5, "+\n", 2);
    memcpy(str+5*line_length, str, line_length);
    /* middle rows */
    for (ptr=str+line_length, i=0; i<line_length; i+=5, ptr+=5)
        memcpy(ptr, "|    ", 5);
    memcpy(ptr-5, "|\n", 2);
    memcpy(str+2*line_length, str+line_length, line_length);
    memcpy(str+3*line_length, str+line_length, 2*line_length);

    /* copy in the digits */
    for (i=0; i<n_digits; i++)
        make_digit(digits[i], str+1+5*i, line_length);

    return str;
}

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "usage: mayan <number>\n");
        return 1;
    }
    int i = atoi(argv[1]);
    if (i <= 0) {
        fprintf(stderr, "number must be positive\n");
        return 1;
    }
    char *m = mayan(i);
    printf("%s",m);
    free(m);
    return 0;
}
