import std.stdio, std.random, std.math;

struct NormalRandom {
    double mean, stdDev;

    // Necessary because it also defines an opCall.
    this(in double mean_, in double stdDev_) pure nothrow {
        this.mean = mean_;
        this.stdDev = stdDev_;
    }

    double opCall() const /*nothrow*/ {
        immutable r1 = uniform01, r2 = uniform01; // Not nothrow.
        return mean + stdDev * sqrt(-2 * r1.log) * cos(2 * PI * r2);
    }
}

void main() {
    double[1000] array;
    auto nRnd = NormalRandom(1.0, 0.5);
    foreach (ref x; array)
        //x = nRnd;
        x = nRnd();
}
