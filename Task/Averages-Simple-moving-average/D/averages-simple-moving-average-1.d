import std.stdio, std.traits, std.algorithm;

auto sma(T, int period)() pure nothrow @safe {
    T[period] data = 0;
    T sum = 0;
    int index, nFilled;

    return (in T v) nothrow @safe @nogc {
        sum += -data[index] + v;
        data[index] = v;
        index = (index + 1) % period;
        nFilled = min(period, nFilled + 1);
        return CommonType!(T, float)(sum) / nFilled;
    };
}

void main() {
    immutable s3 = sma!(int, 3);
    immutable s5 = sma!(double, 5);

    foreach (immutable e; [1, 2, 3, 4, 5, 5, 4, 3, 2, 1])
        writefln("Added %d, sma(3) = %f, sma(5) = %f", e, s3(e), s5(e));
}
