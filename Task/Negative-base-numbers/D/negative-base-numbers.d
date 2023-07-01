import std.stdio;

immutable DIGITS = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

void main() {
    driver(10, -2);
    driver(146, -3);
    driver(15, -10);
    driver(13, -62);
}

void driver(long n, int b) {
    string ns = encodeNegBase(n, b);
    writefln("%12d encoded in base %3d = %12s", n, b, ns);

    long p = decodeNegBase(ns, b);
    writefln("%12s decoded in base %3d = %12d", ns, b, p);

    writeln;
}

string encodeNegBase(long n, int b) in {
    import std.exception : enforce;
    enforce(b <= -1 && b >= -62);
} body {
    if (n==0) return "0";
    char[] output;
    long nn = n;
    while (nn != 0) {
        int rem = nn % b;
        nn /= b;
        if (rem < 0) {
            nn++;
            rem -= b;
        }
        output ~= DIGITS[rem];
    }

    import std.algorithm : reverse;

    reverse(output);
    return cast(string) output;
}

long decodeNegBase(string ns, int b) in {
    import std.exception : enforce;
    enforce(b <= -1 && b >= -62);
} body {
    if (ns == "0") return 0;
    long total = 0;
    long bb = 1;
    foreach_reverse (c; ns) {
        foreach(i,d; DIGITS) {
            if (c==d) {
                total += i * bb;
                bb *= b;
                break;
            }
        }
    }
    return total;
}
