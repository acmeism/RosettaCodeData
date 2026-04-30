#include <stdlib.h>
#include <stdio.h>
#include <string.h>
void test(char *s) {
    char *s_ptr = strdup(s);
    printf(s_ptr);
    free(s_ptr);
}
