import core.stdc.stdio, std.ascii;

bool isPalindrome2(ulong n) pure nothrow @nogc @safe {
    ulong x = 0;
    if (!(n & 1))
        return !n;
    while (x < n) {
        x = (x << 1) | (n & 1);
        n >>= 1;
    }
    return n == x || n == (x >> 1);
}

ulong reverse3(ulong n) pure nothrow @nogc @safe {
    ulong x = 0;
    while (n) {
        x = x * 3 + (n % 3);
        n /= 3;
    }
    return x;
}

void printReversed(ubyte base)(ulong n) nothrow @nogc {
    ' '.putchar;
    do {
        digits[n % base].putchar;
        n /= base;
    } while(n);

    printf("(%d)", base);
}

void main() nothrow @nogc {
    ulong top = 1, mul = 1, even = 0;
    uint count = 0;

    for (ulong i = 0; true; i++) {
        if (i == top) {
            if (even ^= 1)
                top *= 3;
            else {
                i = mul;
                mul = top;
            }
        }

        immutable n = i * mul + reverse3(even ? i / 3 : i);

        if (isPalindrome2(n)) {
            printf("%llu", n);
            printReversed!3(n);
            printReversed!2(n);
            '\n'.putchar;

            if (++count >= 6) // Print first 6.
                break;
        }
    }
}
