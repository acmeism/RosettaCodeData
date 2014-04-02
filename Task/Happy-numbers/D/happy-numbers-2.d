import std.stdio, std.algorithm, std.range, std.conv;

bool isHappy(int n) pure /*nothrow*/ {
    int[int] seen;

    while (true) {
        immutable t = n.text.map!q{(a - '0') ^^ 2}.sum;
        if (t == 1)
            return true;
        if (t in seen)
            return false;
        n = t;
        seen[t] = 0;
    }
}

void main() {
    int.max.iota.filter!isHappy.take(8).writeln;
}
