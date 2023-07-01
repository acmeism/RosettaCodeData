#include <stdio.h>

int main() {
    int i, j;
    char k[4];
    for (i = 0; i < 16; ++i) {
        for (j = 32 + i; j < 128; j += 16) {
            switch (j) {
                default:  sprintf(k, "%c", j); break;
                case 32:  sprintf(k, "Spc"); break;
                case 127: sprintf(k, "Del"); break;
            }
            printf("%3d : %-3s   ", j, k);
        }
        printf("\n");
    }
    return 0;
}
