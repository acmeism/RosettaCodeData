#include <stdlib.h>
#include <stdio.h>

static int digits(const int x) {
    if (x / 10 == 0) return 1;
    return 1 + digits(x / 10);
}

static char * get_ordinal(const int i) {
    const int string_size = digits(i) + 3;
    char * o_number = malloc(string_size);
    char * ordinal;
    if(i % 100 >= 11 && i % 100 <= 13) ordinal = "th";
    else ordinal = i/10==1?"th":i%10==1?"st":i%10==2?"nd":i%10==3?"rd":"th";
    sprintf_s(o_number, string_size, "%d%s", i, ordinal);
    return o_number;
}

static void print_range(const int begin, const int end) {
    printf("Set [%d,%d]:\n", begin, end);
    for (int i = begin; i <= end; i++) {
        char * o_number = get_ordinal(i);
        printf("%s ", o_number);
        free(o_number);
    }
    printf("\n");
}

int main(void) {
    print_range(0, 25);
    print_range(250, 265);
    print_range(1000, 1025);
}
