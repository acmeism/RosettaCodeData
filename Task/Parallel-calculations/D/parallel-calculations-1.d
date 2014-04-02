ulong[] decompose(ulong n) pure nothrow {
    typeof(return) result;
    for (ulong i = 2; n >= i * i; i++)
        for (; n % i == 0; n /= i)
            result ~= i;
    if (n != 1)
        result ~= n;
    return result;
}

void main() {
    import std.stdio, std.algorithm, std.parallelism, std.typecons;

    immutable ulong[] data = [
        2UL^^59-1, 2UL^^59-1, 2UL^^59-1, 112_272_537_195_293UL,
        115_284_584_522_153, 115_280_098_190_773,
        115_797_840_077_099, 112_582_718_962_171,
        112_272_537_095_293, 1_099_726_829_285_419];

    //auto factors = taskPool.amap!(n => tuple(decompose(n), n))(data);
    //static enum genPair = (ulong n) pure => tuple(decompose(n), n);
    static genPair(ulong n) pure { return tuple(decompose(n), n); }
    auto factors = taskPool.amap!genPair(data);

    auto pairs = factors.map!(p => tuple(p[0].reduce!min, p[1]));
    writeln("N. with largest min factor: ", pairs.reduce!max[1]);
}
