#include <stdio.h>
#include <math.h>
#include <stdlib.h>

// AU header (CD-quality audio)
int header[] = {46, 115, 110, 100, 0, 0, 0, 24,
                255, 255, 255, 255, 0, 0, 0, 3,
                0, 0, 172, 68, 0, 0, 0, 1};

int main(int argc, char *argv[]){
        float freq, dur;
        long i, v;

        if (argc < 3) {
                printf("Usage:\n");
                printf("  csine <frequency> <duration>\n");
                exit(1);
        }
        freq = atof(argv[1]);
        dur = atof(argv[2]);
        for (i = 0; i < 24; i++)
                putchar(header[i]);
        for (i = 0; i < dur * 44100; i++) {
                v = (long) round(32000. * sin(2. * M_PI * freq * i / 44100.));
                v = v % 65536;
                putchar(v >> 8);
                putchar(v % 256);
        }
}
