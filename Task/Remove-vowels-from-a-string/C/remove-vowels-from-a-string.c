#include <stdio.h>

void print_no_vowels(const char *s) {
    for (; *s != 0; s++) {
        switch (*s) {
        case 'A':
        case 'E':
        case 'I':
        case 'O':
        case 'U':
        case 'a':
        case 'e':
        case 'i':
        case 'o':
        case 'u':
            break;
        default:
            putchar(*s);
            break;
        }
    }
}

void test(const char *const s) {
    printf("Input  : %s\n", s);

    printf("Output : ");
    print_no_vowels(s);
    printf("\n");
}

int main() {
    test("C Programming Language");
    return 0;
}
