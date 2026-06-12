import std.math;
import std.stdio;

// See https://en.wikipedia.org/wiki/Divisor_function
uint divisorCount(uint n) {
    uint total = 1;
    // Deal with powers of 2 first
    for (; (n & 1) == 0; n >>= 1) {
        total++;
    }
    // Odd prime factors up to the square root
    for (uint p = 3; p * p <= n; p += 2) {
        uint count = 1;
        for (; n % p == 0; n /= p) {
            count++;
        }
        total *= count;
    }
    // If n > 1 then it's prime
    if (n > 1) {
        total *= 2;
    }
    return total;
}

uint divisorProduct(uint n) {
    return cast(uint) pow(n, divisorCount(n) / 2.0);
}

void main() {
    immutable limit = 50;
    writeln("Product of divisors for the first ", limit, "positive integers:");
    for (uint n = 1; n <= limit; n++) {
        writef("%11d", divisorProduct(n));
        if (n % 5 == 0) {
            writeln;
        }
    }
}
