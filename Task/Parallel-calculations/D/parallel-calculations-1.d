import std.stdio, std.algorithm, std.parallelism, std.typecons;

void main() {
    immutable ulong[] data = [
        2UL^^59-1, 2UL^^59-1, 2UL^^59-1, 112_272_537_195_293UL,
        115_284_584_522_153, 115_280_098_190_773,
        115_797_840_077_099, 112_582_718_962_171,
        112_272_537_095_293, 1_099_726_829_285_419];

    //auto factors = taskPool.amap!(n => tuple(decompose(n), n))(data);
    static genPair(ulong n) pure { return tuple(decompose(n), n); }
    auto factors = taskPool.amap!genPair(data);

    auto pairs = map!(p => tuple(reduce!min(p[0]), p[1]))(factors);
    writeln("N. with largest min factor: ", reduce!max(pairs)[1]);
}
