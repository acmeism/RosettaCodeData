#include <stdio.h>
#include <string.h>

void print_verse(const char *name) {
    char *x, *y;
    int b = 1, f = 1, m = 1, i = 1;

    /* ensure name is in title-case */
    x = strdup(name);
    x[0] = toupper(x[0]);
    for (; x[i]; ++i) x[i] = tolower(x[i]);

    if (strchr("AEIOU", x[0])) {
        y = strdup(x);
        y[0] = tolower(y[0]);
    }
    else {
        y = x + 1;
    }

    switch(x[0]) {
        case 'B': b = 0; break;
        case 'F': f = 0; break;
        case 'M': m = 0; break;
        default : break;
    }

    printf("%s, %s, bo-%s%s\n", x, x, (b) ? "b" : "", y);
    printf("Banana-fana fo-%s%s\n", (f) ? "f" : "", y);
    printf("Fee-fi-mo-%s%s\n", (m) ? "m" : "", y);
    printf("%s!\n\n", x);
}

int main() {
    int i;
    const char *names[6] = {"gARY", "Earl", "Billy", "Felix", "Mary", "sHIRley"};
    for (i = 0; i < 6; ++i) print_verse(names[i]);
    return 0;
}
