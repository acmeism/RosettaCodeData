#include <stdio.h>
#include <stdlib.h>

#define RANDOM_PATH "/dev/urandom"

int main(void)
{
        unsigned char buf[4];
        unsigned long v;
        FILE *fin;

        if ((fin = fopen(RANDOM_PATH, "r")) == NULL) {
                fprintf(stderr, "%s: unable to open file\n", RANDOM_PATH);
                return EXIT_FAILURE;
        }
        if (fread(buf, 1, sizeof buf, fin) != sizeof buf) {
                fprintf(stderr, "%s: not enough bytes (expected %u)\n",
                        RANDOM_PATH, (unsigned) sizeof buf);
                return EXIT_FAILURE;
        }
        fclose(fin);
        v = buf[0] | buf[1] << 8UL | buf[2] << 16UL | buf[3] << 24UL;
        printf("%lu\n", v);
        return 0;
}
