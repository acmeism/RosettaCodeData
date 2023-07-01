import std.stdio, std.algorithm, std.range, std.array;

uint[] narcissists(in uint m) pure nothrow @safe {
    typeof(return) result;

    foreach (immutable uint digits; 0 .. 10) {
        const digitPowers = 10.iota.map!(i => i ^^ digits).array;

        foreach (immutable uint n; 10 ^^ (digits - 1) .. 10 ^^ digits) {
            uint digitPSum, div = n;
            while (div) {
                digitPSum += digitPowers[div % 10];
                div /= 10;
            }

            if (n == digitPSum) {
                result ~= n;
                if (result.length >= m)
                    return result;
            }
        }
    }

    assert(0);
}

void main() {
    writefln("%(%(%d %)\n%)", 25.narcissists.chunks(5));
}
