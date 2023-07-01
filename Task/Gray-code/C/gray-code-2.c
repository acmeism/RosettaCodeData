#include <stdio.h>

/* Simple bool formatter, only good on range 0..31 */
void fmtbool(int n, char *buf) {
    char *b = buf + 5;
    *b=0;
    do {
	*--b = '0' + (n & 1);
	n >>= 1;
    } while (b != buf);
}

int main(int argc, char **argv) {
    int i,g,b;
    char bi[6],bg[6],bb[6];

    for (i=0 ; i<32 ; i++) {
	g = gray_encode(i);
	b = gray_decode(g);
	fmtbool(i,bi); fmtbool(g,bg); fmtbool(b,bb);
	printf("%2d : %5s => %5s => %5s : %2d\n", i, bi, bg, bb, b);
    }
    return 0;
}
