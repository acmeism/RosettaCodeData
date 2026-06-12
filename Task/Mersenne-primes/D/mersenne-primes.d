import std.bigint;
import std.stdio;

bool isPrime(BigInt bi) {
    if (bi < 2) return false;
    if (bi % 2 == 0) return bi == 2;
    if (bi % 3 == 0) return bi == 3;

    auto test = BigInt(5);
    while (test * test < bi) {
        if (bi % test == 0) return false;
        test += 2;
        if (bi % test == 0) return false;
        test += 4;
    }

    return true;
}

void main() {
    auto base = BigInt(2);

    for (int pow=1; pow<32; pow++) {
        if (isPrime(base-1)) {
            writeln("2 ^ ", pow, " - 1");
        }
        base *= 2;
    }
}
