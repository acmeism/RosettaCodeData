import std.stdio, std.algorithm, std.range, std.math;

bool isPrime(in int n) pure nothrow {
    if ((n & 1) == 0 || n <= 1)
        return n == 2;

    for(int i = 3; i <= sqrt(cast(real)n); i += 2)
        if (n % i == 0)
            return false;
    return true;
}

void main() { // demo code
    iota(2, 40).filter!isPrime().writeln();
}
