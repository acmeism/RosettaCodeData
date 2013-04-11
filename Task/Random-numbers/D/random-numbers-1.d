import std.stdio, std.random, std.math;

struct NormalRandom {
    double mean, stdDev;

    // needed because it also defines an opCall
    this(in double mean_, in double stdDev_) pure nothrow {
        this.mean = mean_;
        this.stdDev = stdDev_;
    }

    double opCall() const /*nothrow*/ {
        immutable double r1 = uniform(0.0, 1.0);
        immutable double r2 = uniform(0.0, 1.0);
        return mean + stdDev * sqrt(-2 * log(r1)) * cos(2 * PI * r2);
    }
}

void main() {
    double[1000] array;
    auto nrnd = NormalRandom(1.0, 0.5);
    foreach (ref x; array)
        x = nrnd();
}
