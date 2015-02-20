import core.stdc.stdio, std.algorithm, std.range;

enum factorial = (in uint n) pure nothrow @safe @nogc
    => reduce!q{a * b}(1u, iota(1u, n + 1));

uint iLog10(in uint x) pure nothrow @safe @nogc
in {
    assert(x > 0);
} body {
    return (x >= 1_000_000_000) ? 9 :
           (x >=   100_000_000) ? 8 :
           (x >=    10_000_000) ? 7 :
           (x >=     1_000_000) ? 6 :
           (x >=       100_000) ? 5 :
           (x >=        10_000) ? 4 :
           (x >=         1_000) ? 3 :
           (x >=           100) ? 2 :
           (x >=            10) ? 1 : 0;
}

uint nextStep(uint x) pure nothrow @safe @nogc {
    typeof(return) result = 0;

    while (x > 0) {
        result += (x % 10) ^^ 2;
        x /= 10;
    }
    return result;
}

uint check(in uint[] number) pure nothrow @safe @nogc {
    uint candidate = reduce!((tot, n) => tot * 10 + n)(0, number);

    while (candidate != 89 && candidate != 1)
        candidate = candidate.nextStep;

    if (candidate == 89) {
        uint[10] digitsCount;
        foreach (immutable d; number)
            digitsCount[d]++;

        return reduce!((r, c) => r / c.factorial)
                      (number.length.factorial, digitsCount);
    }

    return 0;
}

void main() nothrow @nogc {
    enum uint limit = 100_000_000;
    immutable uint cacheSize = limit.iLog10;

    uint[cacheSize] number;
    uint result = 0;
    uint i = cacheSize - 1;

    while (true) {
        if (i == 0 && number[i] == 9)
            break;
        if (i == cacheSize - 1 && number[i] < 9) {
            number[i]++;
            result += number.check;
        } else if (number[i] == 9) {
            i--;
        } else {
            number[i]++;
            number[i + 1 .. $] = number[i];
            i = cacheSize - 1;
            result += number.check;
        }
    }

    printf("%u\n", result);
}
