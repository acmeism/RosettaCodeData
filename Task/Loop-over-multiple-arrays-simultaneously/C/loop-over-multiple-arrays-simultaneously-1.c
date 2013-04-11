#include <stdio.h>

char a1[] = {'a','b','c'};
char a2[] = {'A','B','C'};
int a3[] = {1,2,3};

int main(void) {
    for (int i = 0; i < 3; i++) {
        printf("%c%c%i\n", a1[i], a2[i], a3[i]);
    }
}
