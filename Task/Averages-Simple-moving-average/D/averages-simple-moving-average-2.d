import std.stdio, std.traits, std.algorithm;

struct SMA(T, int period) {
    T[period] data = 0;
    T sum = 0;
    int index, nfilled;

    auto opCall(in T v) pure nothrow {
        sum += -data[index] + v;
        data[index] = v;
        index = (index + 1) % period;
        nfilled = min(period, nfilled + 1);
        return cast(CommonType!(T, float))sum / nfilled;
    }
}

void main() {
    SMA!(int, 3) s3;
    SMA!(double, 5) s5;

    foreach (e; [1, 2, 3, 4, 5, 5, 4, 3, 2, 1])
        writefln("Added %d, sma(3) = %f, sma(5) = %f",
                 e, s3(e), s5(e));
}
