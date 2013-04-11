import std.stdio, std.conv, std.algorithm, std.math;

long sgn(alias unsignedFib)(int n) { // break sign manipulation apart
    immutable uint m = (n >= 0) ? n : -n;
    if (n < 0 && (n % 2 == 0))
        return -unsignedFib(m);
    else
        return unsignedFib(m);
}

long fibD(uint m) { // Direct Calculation, correct for abs(m) <= 84
    enum sqrt5r =  1.0L / sqrt(5.0L);         //  1 / sqrt(5)
    enum golden = (1.0L + sqrt(5.0L)) / 2.0L; // (1 + sqrt(5)) / 2
    return roundTo!long(pow(golden, m) * sqrt5r);
}

long fibI(in uint m) pure nothrow { // Iterative
    long thisFib = 0;
    long nextFib = 1;
    foreach (i; 0 .. m) {
        long tmp = nextFib;
        nextFib += thisFib;
        thisFib  = tmp;
    }
    return thisFib;
}

long fibR(uint m) { // Recursive
    return (m < 2) ? m : fibR(m - 1) + fibR(m - 2);
}

long fibM(uint m) { // memoized Recursive
    static long[] fib = [0, 1];
    while (m >= fib.length )
        fib ~= fibM(m - 2) + fibM(m - 1);
    return fib[m];
}

alias sgn!fibD sfibD;
alias sgn!fibI sfibI;
alias sgn!fibR sfibR;
alias sgn!fibM sfibM;

auto fibG(in int m) { // generator(?)
    immutable int sign = (m < 0) ? -1 : 1;
    long yield;

    return new class {
        final int opApply(int delegate(ref int, ref long) dg) {
            int idx = -sign; // prepare for pre-increment
            foreach (f; this)
                if (dg(idx += sign, f))
                    break;
            return 0;
        }

        final int opApply(int delegate(ref long) dg) {
            long f0, f1 = 1;
            foreach (p; 0 .. m * sign + 1) {
                if (sign == -1 && (p % 2 == 0))
                    yield = -f0;
                else
                    yield = f0;
                if (dg(yield)) break;
                auto temp = f1;
                f1 = f0 + f1;
                f0 = temp;
            }
            return 0;
        }
    };
}

void main(in string[] args) {
    int k = args.length > 1 ? to!int(args[1]) : 10;
    writefln("Fib(%3d) = ", k);
    writefln("D : %20d <- %20d + %20d",
             sfibD(k), sfibD(k - 1), sfibD(k - 2));
    writefln("I : %20d <- %20d + %20d",
             sfibI(k), sfibI(k - 1), sfibI(k - 2));
    if (abs(k) < 36 || args.length > 2)
        // set a limit for recursive version
        writefln("R : %20d <- %20d + %20d",
                 sfibR(k), sfibM(k - 1), sfibM(k - 2));
    writefln("O : %20d <- %20d + %20d",
             sfibM(k), sfibM(k - 1), sfibM(k - 2));
    foreach (i, f; fibG(-9))
        writef("%d:%d | ", i, f);
}
