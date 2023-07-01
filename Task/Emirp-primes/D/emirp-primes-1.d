bool isEmirp(uint n) pure nothrow @nogc {
    bool isPrime(in uint n) pure nothrow @nogc {
        if (n == 2 || n == 3)
            return true;
        else if (n < 2 || n % 2 == 0 || n % 3 == 0)
            return false;
        for (uint div = 5, inc = 2; div ^^ 2 <= n;
             div += inc, inc = 6 - inc)
            if (n % div == 0)
                return false;

        return true;
    }

    uint reverse(uint n) pure nothrow @nogc {
        uint r;
        for (r = 0; n; n /= 10)
            r = r * 10 + (n % 10);
        return r;
    }

    immutable r = reverse(n);
    return r != n && isPrime(n) && isPrime(r);
}

void main() {
    import std.stdio, std.algorithm, std.range;

    auto uints = uint.max.iota;
    writeln("First 20:\n", uints.filter!isEmirp.take(20));
    writeln("Between 7700 and 8000:\n",
            iota(7_700, 8_001).filter!isEmirp);
    writeln("10000th: ", uints.filter!isEmirp.drop(9_999).front);
}
