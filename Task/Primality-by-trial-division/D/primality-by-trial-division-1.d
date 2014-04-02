import std.stdio, std.algorithm, std.range, std.math;

bool isPrime1(in int n) pure nothrow {
    if (n == 2)
        return true;
    if (n <= 1 || (n & 1) == 0)
        return false;

    for(int i = 3; i <= real(n).sqrt; i += 2)
        if (n % i == 0)
            return false;
    return true;
}

void main() {
    iota(2, 40).filter!isPrime1.writeln;
}
