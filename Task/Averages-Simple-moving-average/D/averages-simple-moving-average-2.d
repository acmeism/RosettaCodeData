import std.stdio, std.traits, std.algorithm;

struct SMA(T, int period) {
    T[period] data = 0;
    T sum = 0;
    int index, nFilled;

    auto opCall(in T v) pure nothrow @safe @nogc {
        sum += -data[index] + v;
        data[index] = v;
        index = (index + 1) % period;
        nFilled = min(period, nFilled + 1);
        return CommonType!(T, float)(sum) / nFilled;
    }
}

void main() {
    SMA!(int, 3) s3;
    SMA!(double, 5) s5;

    foreach (immutable e; [1, 2, 3, 4, 5, 5, 4, 3, 2, 1])
        writefln("Added %d, sma(3) = %f, sma(5) = %f", e, s3(e), s5(e));
}
