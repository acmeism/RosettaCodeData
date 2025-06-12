#include <stdio.h>

void split(const char *src, char *dst) {
    const char *src_tmp = src;
    char *dst_tmp = dst;

    while (*src_tmp != '\0') {
        int i = 0;

        // scan for the next change of character occurrence
        while (*(src_tmp + ++i) == *src_tmp)
            ;

        // copy the sequence of repeated characters to the destination buffer
        snprintf(dst_tmp, i + 1, "%s", src_tmp);

        // add a comma or null character (if end of string) to the destination
        // buffer and advance both the source and destination pointers
        snprintf(dst_tmp += i, 3, "%s", *(src_tmp += i) == '\0' ? "\0" : ", ");
        dst_tmp += 2;
    }
}

int main(void) {
    const char *str = "gHHH5YY++///\\";
    char out[100]; // must be large enough to hold the result

    split(str, out);
    printf("%s\n", out);

    return 0;
}
