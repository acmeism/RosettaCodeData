#define _CRT_SECURE_NO_WARNINGS    // turn off panic warnings
#define _CRT_NONSTDC_NO_DEPRECATE   // enable old-gold POSIX names in MSVS

#include <stdio.h>
#include <stdlib.h>


char* bin2str(unsigned value, char* buffer)
{
    // This algorithm is not the fastest one, but is relativelly simple.
    //
    // A faster algorithm would be conversion octets to strings by a lookup table.
    // There is only 2**8 == 256 octets, therefore we would need only 2048 bytes
    // for the lookup table. Conversion of a 64-bit integers would need 8 lookups
    // instead 64 and/or/shifts of bits etc. Even more... lookups may be implemented
    // with XLAT or similar CPU instruction... and AVX/SSE gives chance for SIMD.

    const unsigned N_DIGITS = sizeof(unsigned) * 8;
    unsigned mask = 1 << (N_DIGITS - 1);
    char* ptr = buffer;

    for (int i = 0; i < N_DIGITS; i++)
    {
        *ptr++ = '0' + !!(value & mask);
        mask >>= 1;
    }
    *ptr = '\0';

    // Remove leading zeros.
    //
    for (ptr = buffer; *ptr == '0'; ptr++)
        ;

    return ptr;
}


char* bin2strNaive(unsigned value, char* buffer)
{
    // This variation of the solution doesn't use bits shifting etc.

    unsigned n, m, p;

    n = 0;
    p = 1;  // p = 2 ** n
    while (p <= value / 2)
    {
        n = n + 1;
        p = p * 2;
    }

    m = 0;
    while (n > 0)
    {
        buffer[m] = '0' + value / p;
        value = value % p;
        m = m + 1;
        n = n - 1;
        p = p / 2;
    }

    buffer[m + 1] = '\0';
    return buffer;
}


int main(int argc, char* argv[])
{
    const unsigned NUMBERS[] = { 5, 50, 9000 };

    const int RADIX = 2;
    char buffer[(sizeof(unsigned)*8 + 1)];

    // Function itoa is an POSIX function, but it is not in C standard library.
    // There is no big surprise that Microsoft deprecate itoa because POSIX is
    // "Portable Operating System Interface for UNIX". Thus it is not a good
    // idea to use _itoa instead itoa: we lost compatibility with POSIX;
    // we gain nothing in MS Windows (itoa-without-underscore is not better
    // than _itoa-with-underscore). The same holds for kbhit() and _kbhit() etc.
    //
    for (int i = 0; i < sizeof(NUMBERS) / sizeof(unsigned); i++)
    {
        unsigned value = NUMBERS[i];
        itoa(value, buffer, RADIX);
        printf("itoa:          %u decimal = %s binary\n", value, buffer);
    }

    // Yeep, we can use a homemade bin2str function. Notice that C is very very
    // efficient (as "hi level assembler") when bit manipulation is needed.
    //
    for (int i = 0; i < sizeof(NUMBERS) / sizeof(unsigned); i++)
    {
        unsigned value = NUMBERS[i];
        printf("bin2str:       %u decimal = %s binary\n", value, bin2str(value, buffer));
    }

    // Another implementation - see above.
    //
    for (int i = 0; i < sizeof(NUMBERS) / sizeof(unsigned); i++)
    {
        unsigned value = NUMBERS[i];
        printf("bin2strNaive:  %u decimal = %s binary\n", value, bin2strNaive(value, buffer));
    }

    return EXIT_SUCCESS;
}
