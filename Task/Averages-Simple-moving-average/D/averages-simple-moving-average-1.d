import std.stdio, std.traits, std.algorithm;

auto sma(T, int period)() {
    T[period] data = 0; // D FP are default-initialized to NaN
    T sum = 0;
    int index, nfilled;

    // return (in T v) nothrow {
    return delegate (in T v) nothrow {
        sum += -data[index] + v;
        data[index] = v;
        index = (index + 1) % period;
        nfilled = min(period, nfilled + 1);
        return cast(CommonType!(T, float))sum / nfilled;
    };
}

void main() {
    auto s3 = sma!(int, 3)();
    auto s5 = sma!(double, 5)();

    foreach (e; [1, 2, 3, 4, 5, 5, 4, 3, 2, 1])
        writefln("Added %d, sma(3) = %f, sma(5) = %f",
                 e, s3(e), s5(e));
}
