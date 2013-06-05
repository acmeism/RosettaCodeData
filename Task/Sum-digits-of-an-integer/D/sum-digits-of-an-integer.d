import std.stdio, std.bigint;

uint sumDigits(T)(T n, in uint base=10) /*pure nothrow*/
in {
    assert(base > 1);
} body {
    typeof(return) total = 0;
    for ( ; n; n /= base)
        total += n % base;
    return total;
}

void main() {
    sumDigits(1).writeln;
    sumDigits(1_234).writeln;
    sumDigits(0xfe, 16).writeln;
    sumDigits(0xf0e, 16).writeln;
    sumDigits(1_234.BigInt).writeln;
}
