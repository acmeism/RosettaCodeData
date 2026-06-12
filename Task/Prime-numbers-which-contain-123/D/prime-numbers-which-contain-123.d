import std.stdio, std.range, std.algorithm, std.format, std.conv;

bool isPrime(int n) {
    if (n <= 1) return false;
    for (int i = 2; i * i <= n; i++)
        if (n % i == 0)
            return false;
    return true;
}

bool condition(int n) {
    return isPrime(n) && to!string(n).canFind("123");
}

void main() {
    writefln("%(%(%6d %)\n%)", iota(100000).filter!condition.chunks(10));
    writefln("There are %d such numbers below 1000000.",
        iota(1000000).filter!condition.array.length);
}
