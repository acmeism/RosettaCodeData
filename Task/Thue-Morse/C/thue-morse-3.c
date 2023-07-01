 #include <stdio.h>

/**
 * description : Counts the number of bits set to 1
 *        input: the number to have its bit counted
 *       output: the number of bits set to 1
 */
unsigned count_bits(unsigned v) {
    unsigned c = 0;
    while (v) {
        c += v & 1;
        v >>= 1;
    }

    return c;
}

int main(void) {
    /*          i: loop iterator
     *     length: the length of the sequence to be printed
     * ascii_base: the lower char for use when printing
     */
    unsigned i, length = 0;
    int ascii_base;


    /* scan in sequence length */
    printf("Sequence length: ");
    do {
        scanf("%u", &length);
    } while (length == 0);


    /* scan in sequence mode */
    printf("(a)lpha or (b)inary: ");
    do {
        ascii_base = getchar();
    } while ((ascii_base != 'a') && (ascii_base != 'b'));
    ascii_base = ascii_base == 'b' ? '0' : 'A';


    /* print the Thue-Morse sequence */
    for (i = 0; i < length; ++i) {
        putchar(ascii_base + count_bits(i) % 2);
    }
    putchar('\n');

    return 0;
}
