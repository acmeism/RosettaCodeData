import std.stdio, std.algorithm, std.range, std.math;

bool isPrime3(T)(in T n) pure nothrow {
    if (n % 2 == 0 || n <= 1)
        return n == 2;
    T head = 3, tail = (cast(T)sqrt(cast(real)n) / 2) * 2 + 1;
    for ( ; head <= tail ; head +=2, tail -= 2)
        if ((n % head) == 0 || (n % tail) == 0)
            return false;
    return true;
}

void main() { // demo code
    iota(2, 40).filter!isPrime3().writeln();
}
