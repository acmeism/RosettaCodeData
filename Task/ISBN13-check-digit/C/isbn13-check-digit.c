#include <stdio.h>

int check_isbn13(const char *isbn) {
    int ch = *isbn, count = 0, sum = 0;
    /* check isbn contains 13 digits and calculate weighted sum */
    for ( ; ch != 0; ch = *++isbn, ++count) {
        /* skip hyphens or spaces */
        if (ch == ' ' || ch == '-') {
            --count;
            continue;
        }
        if (ch < '0' || ch > '9') {
            return 0;
        }
        if (count & 1) {
            sum += 3 * (ch - '0');
        } else {
            sum += ch - '0';
        }
    }
    if (count != 13) return 0;
    return !(sum%10);
}

int main() {
    int i;
    const char* isbns[] = {"978-0596528126", "978-0596528120", "978-1788399081", "978-1788399083"};
    for (i = 0; i < 4; ++i) {
        printf("%s: %s\n", isbns[i], check_isbn13(isbns[i]) ? "good" : "bad");
    }
    return 0;
}
