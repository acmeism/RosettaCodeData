#include <stdio.h>
#include <stdlib.h>

const char * board =  "ET AON RIS"
                      "BCDFGHJKLM"
                      "PQ/UVWXYZ.";

char encode[128] = {0};
char decode[128] = {0};
int row[2] = {0};

void read_table(const char *s)
{
        int i, code;
        for (i = 0; i < 30; i++) {
                if (s[i] == '\0') {
                        fprintf(stderr, "Table too short\n");
                        exit(1);
                }

                if (s[i] == ' ') {
                        row[  row[0] ? 1 : 0 ] = i;
                        continue;
                }

                code = ((i < 10) ? 0 : i < 20 ? row[0] : row[1])
                                * 10 + (i % 10);
                encode[0 + s[i]] = code; /* guess what 0 + s[i] does, sigh */
                decode[code] = s[i];
        }
}

void encipher(const char *in, char *out, int strip)
{
#define PUTCODE(c) { if (c > 9) {*(out++) = c / 10 + '0'; c %= 10;} *(out++) = c + '0'; }
        int c, code;
        while ((c = *(in++)) != '\0') {
                if (c >= '0' && c <= '9') {
                        code = encode['.'];
                        c -= '0';
                        PUTCODE(code);
                        PUTCODE(c);
                        continue;
                }

                c &= ~0x20;

                if (c >= 'A' && c <= 'Z') code = encode[c];
                else if (strip && !c )    continue;
                else                      code = encode['/'];

                PUTCODE(code);
        }
        *(out++) = '\0';
}

void decipher(const char *in, char *out, int strip)
{
        int c;
        while ((c = *(in++)) != '\0') {
                c -= '0';
                if (c == row[0] || c == row[1])
                        c = c * 10 + *(in++) - '0';

                c = decode[c];

                if (c == '.') c = *(in++);
                if (c == '/' && !strip) c = ' ';
                *(out++) = c;
        }
        *(out++) = '\0';
}

int main()
{
        const char *msg = "In the winter 1965/we were hungry/just barely alive";
        char enc[100] = {0}, dec[100] = {0};
        read_table(board);

        printf("message: %s\n", msg);
        encipher(msg, enc, 0); printf("encoded: %s\n", enc);
        decipher(enc, dec, 0); printf("decoded: %s\n", dec);

        printf("\nNo spaces:\n");
        encipher(msg, enc, 1); printf("encoded: %s\n", enc);
        decipher(enc, dec, 1); printf("decoded: %s\n", dec);
        return 0;
}
