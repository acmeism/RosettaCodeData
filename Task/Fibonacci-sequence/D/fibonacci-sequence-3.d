import std.bigint, std.math;

// Algorithm from: Takahashi, Daisuke,
// "A fast algorithm for computing large Fibonacci numbers".
// Information Processing Letters 75.6 (30 November 2000): 243-246.
// Implementation from:
// pythonista.wordpress.com/2008/07/03/pure-python-fibonacci-numbers
BigInt fibonacci(in ulong n)
in {
    assert(n > 0, "fibonacci(n): n must be > 0.");
} body {
    if (n <= 2)
        return 1.BigInt;
    BigInt F = 1;
    BigInt L = 1;
    int sign = -1;
    immutable uint n2 = cast(uint)n.log2.floor;
    auto mask = 2.BigInt ^^ (n2 - 1);
    foreach (immutable i; 1 .. n2) {
        auto temp = F ^^ 2;
        F = (F + L) / 2;
        F = 2 * F ^^ 2 - 3 * temp - 2 * sign;
        L = 5 * temp + 2 * sign;
        sign = 1;
        if (n & mask) {
            temp = F;
            F = (F + L) / 2;
            L = F + 2 * temp;
            sign = -1;
        }
        mask /= 2;
    }
    if ((n & mask) == 0) {
        F *= L;
    } else {
        F = (F + L) / 2;
        F = F * L - sign;
    }
    return F;
}

void main() {
    10_000_000.fibonacci;
}
