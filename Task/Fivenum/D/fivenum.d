import std.algorithm;
import std.exception;
import std.math;
import std.stdio;

double median(double[] x) {
    enforce(x.length >= 0, "Array slice cannot be empty");
    int m = x.length / 2;
    if (x.length % 2 == 1) {
        return x[m];
    }
    return (x[m-1] + x[m]) / 2.0;
}

double[] fivenum(double[] x) {
    foreach (d; x) {
        enforce(!d.isNaN, "Unable to deal with arrays containing NaN");
    }

    double[] result;
    result.length = 5;

    x.sort;
    result[0] = x[0];
    result[2] = median(x);
    result[4] = x[$-1];

    int m = x.length / 2;
    int lower = (x.length % 2 == 1) ? m : m - 1;
    result[1] = median(x[0..lower+1]);
    result[3] = median(x[lower+1..$]);

    return result;
}

void main() {
    double[][] x1 = [
        [15.0, 6.0, 42.0, 41.0, 7.0, 36.0, 49.0, 40.0, 39.0, 47.0, 43.0],
        [36.0, 40.0, 7.0, 39.0, 41.0, 15.0],
        [
            0.14082834,  0.09748790,  1.73131507,  0.87636009, -1.95059594,  0.73438555,
           -0.03035726,  1.46675970, -0.74621349, -0.72588772,  0.63905160,  0.61501527,
           -0.98983780, -1.00447874, -0.62759469,  0.66206163,  1.04312009, -0.10305385,
            0.75775634,  0.32566578
        ]
    ];
    foreach(x; x1) {
        writeln(fivenum(x));
    }
}
