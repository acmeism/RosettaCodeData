import std.stdio;

bool sameDigits(int n, int b) {
    int f = n % b;
    while ((n /= b) > 0) {
        if (n % b != f) {
            return false;
        }
    }
    return true;
}

bool isBrazilian(int n) {
    if (n < 7) return false;
    if (n % 2 == 0) return true;
    for (int b = 2; b < n - 1; ++b) {
        if (sameDigits(n, b)) {
            return true;
        }
    }
    return false;
}

bool isPrime(int n) {
    if (n < 2) return false;
    if (n % 2 == 0) return n == 2;
    if (n % 3 == 0) return n == 3;
    int d = 5;
    while (d * d <= n) {
        if (n % d == 0) return false;
        d += 2;
        if (n % d == 0) return false;
        d += 4;
    }
    return true;
}

void main() {
    foreach (kind; ["", "odd ", "prime "]) {
        bool quiet = false;
        int BigLim = 99999;
        int limit = 20;
        writefln("First %s %sBrazillion numbers:", limit, kind);
        int c = 0;
        int n = 7;
        while (c < BigLim) {
            if (isBrazilian(n)) {
                if (!quiet) write(n, ' ');
                if (++c == limit) {
                    writeln("\n");
                    quiet = true;
                }
            }
            if (quiet && kind != "") continue;
            switch (kind) {
                case "": n++; break;
                case "odd ": n += 2; break;
                case "prime ":
                    while (true) {
                        n += 2;
                        if (isPrime(n)) break;
                    }
                    break;
                default: assert(false);
            }
        }
        if (kind == "") writefln("The %sth Brazillian number is: %s\n", BigLim + 1, n);
    }
}
