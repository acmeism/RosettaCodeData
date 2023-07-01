#include <stdio.h>
#include <stdlib.h>

#define MONAD void*
#define INTBIND(f, g, x) (f((int*)g(x)))
#define RETURN(type,x) &((type)*)(x)

MONAD boundInt(int *x) {
    return (MONAD)(x);
}

MONAD boundInt2str(int *x) {
    char buf[100];
    char*str= malloc(1+sprintf(buf, "%d", *x));
    sprintf(str, "%d", *x);
    return (MONAD)(str);
}

void task(int y) {
    char *z= INTBIND(boundInt2str, boundInt, &y);
    printf("%s\n", z);
    free(z);
}

int main() {
    task(13);
}
