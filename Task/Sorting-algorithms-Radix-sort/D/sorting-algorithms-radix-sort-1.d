import std.stdio, std.math, std.traits, std.range, std.algorithm;

ElementType!R[] radixSort(size_t N=10, R)(R r)
if (hasLength!R && isRandomAccessRange!R &&
    isIntegral!(ElementType!R)) {
    alias ElementType!R E;

    static if (isDynamicArray!R)
        alias r res;         // input is array => in place sort
    else
        E[] res = r.array(); // input is Range => return a new array

    E absMax = r.map!abs().reduce!max();
    immutable nPasses = 1 + cast(int)(log(absMax) / log(N));

    foreach (pass; 0 .. nPasses) {
        auto bucket = new E[][](2 * N - 1, 0);
        foreach (v; res) {
            int bIdx = abs(v / (N ^^ pass)) % N;
            bIdx = (v < 0) ? -bIdx : bIdx;
            bucket[N + bIdx - 1] ~= v;
        }
        res = bucket.join();
    }

    return res;
}

void main() {
    auto items = [170, 45, 75, -90, 2, 24, -802, 66];
    items.radixSort().writeln();
    items.map!q{1 - a}().radixSort().writeln();
}
