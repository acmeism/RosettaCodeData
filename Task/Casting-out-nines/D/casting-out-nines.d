import std.stdio, std.algorithm, std.range;

uint[] castOut(in uint base=10, in uint start=1, in uint end=999999) {
    auto ran = iota(base - 1)
               .filter!(x => x % (base - 1) == (x * x) % (base - 1));
    auto x = start / (base - 1);
    immutable y = start % (base - 1);

    typeof(return) result;
    while (true) {
        foreach (immutable n; ran) {
            immutable k = (base - 1) * x + n;
            if (k < start)
                continue;
            if (k > end)
                return result;
            result ~= k;
        }
        x++;
    }
}

void main() {
    castOut(16, 1, 255).writeln;
    castOut(10, 1, 99).writeln;
    castOut(17, 1, 288).writeln;
}
