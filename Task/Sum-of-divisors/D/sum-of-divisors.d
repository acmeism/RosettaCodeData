import std.stdio;

// See https://en.wikipedia.org/wiki/Divisor_function
uint divisor_sum(uint n) {
    uint total = 1, power = 2;
    // Deal with powers of 2 first
    for (; (n & 1) == 0; power <<= 1, n >>= 1) {
        total += power;
    }
    // Odd prime factors up to the square root
    for (uint p = 3; p * p <= n; p += 2) {
        uint sum = 1;
        for (power = p; n % p == 0; power *= p, n /= p) {
            sum += power;
        }
        total *= sum;
    }
    // If n > 1 then it's prime
    if (n > 1) {
        total *= n + 1;
    }
    return total;
}

void main() {
    immutable limit = 100;
    writeln("Sum of divisors for the first ", limit," positive integers:");
    for (uint n = 1; n <= limit; ++n) {
        writef("%4d", divisor_sum(n));
        if (n % 10 == 0) {
            writeln;
        }
    }
}
