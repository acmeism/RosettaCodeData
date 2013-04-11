import std.stdio, std.bigint;

T fibonacciMatrix(T=BigInt)(size_t n) {
    int[size_t.sizeof * 8] binDigits;
    size_t nBinDigits;
    while (n > 0) {
        binDigits[nBinDigits] = n % 2;
        n /= 2;
        nBinDigits++;
    }

    T x=1, y, z=1;
    foreach_reverse (b; binDigits[0 .. nBinDigits]) {
        if (b) {
            x = (x + z) * y;
            y = y ^^ 2 + z ^^ 2;
        } else {
            auto x_old = x;
            x = x ^^ 2 + y ^^ 2;
            y = (x_old + z) * y;
        }
        z = x + y;
    }

    return y;
}

void main() {
    writeln(fibonacciMatrix(1_000_000));
}
