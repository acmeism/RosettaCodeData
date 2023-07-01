import std.stdio, std.math, std.algorithm, std.array, grayscale_image;

uint cell(in uint n, int x, int y, in uint start=1) pure nothrow @safe @nogc {
    x = x - (n - 1) / 2;
    y = y - n / 2;
    immutable l = 2 * max(x.abs, y.abs);
    immutable d = (y > x) ? (l * 3 + x + y) : (l - x - y);
    return (l - 1) ^^ 2 + d + start - 1;
}

bool[] primes(in uint n, in uint top, in uint start=1) pure nothrow @safe {
    auto isPrime = [false, false, true] ~ [true, false].replicate(top / 2);

    foreach (immutable x; 3 .. 1 + cast(uint)real(top).sqrt)
        if (isPrime[x])
            for (uint i = x ^^ 2; i < top; i += x * 2)
                isPrime[i] = false;
    return isPrime;
}

void main() {
    enum n = 512;
    enum start = 1;
    immutable top = start + n ^^ 2 + 1;
    immutable isPrime = primes(n, top, start);
    auto img = new Image!Gray(n, n);

    foreach (immutable y; 0 .. n)
        foreach (immutable x; 0 .. n)
            img[x, y] = isPrime[cell(n, x, y, start)] ? Gray.black : Gray.white;

    img.savePGM("ulam_spiral.pgm");
}
