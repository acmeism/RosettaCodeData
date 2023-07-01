import std.stdio;

uint divisor_count(uint n) {
    uint total = 1;
    // Deal with powers of 2 first
    for (; (n & 1) == 0; n >>= 1) {
        ++total;
    }
    // Odd prime factors up to the square root
    for (uint p = 3; p * p <= n; p += 2) {
        uint count = 1;
        for (; n % p == 0; n /= p) {
            ++count;
        }
        total *= count;
    }
    // If n > 1 then it's prime
    if (n > 1) {
        total *= 2;
    }
    return total;
}

void main() {
    immutable limit = 100;
    writeln("The first ", limit, " tau numbers are:");
    uint count = 0;
    for (uint n = 1; count < limit; ++n) {
        if (n % divisor_count(n) == 0) {
            writef("%6d", n);
            ++count;
            if (count % 10 == 0) {
                writeln;
            }
        }
    }
}
