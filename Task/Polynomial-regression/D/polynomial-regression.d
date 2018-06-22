import std.algorithm;
import std.range;
import std.stdio;

auto average(R)(R r) {
    auto t = r.fold!("a+b", "a+1")(0, 0);
    return cast(double) t[0] / t[1];
}

void polyRegression(int[] x, int[] y) {
    auto n = x.length;
    auto r = iota(0, n).array;
    auto xm = x.average();
    auto ym = y.average();
    auto x2m = r.map!"a*a".average();
    auto x3m = r.map!"a*a*a".average();
    auto x4m = r.map!"a*a*a*a".average();
    auto xym = x.zip(y).map!"a[0]*a[1]".average();
    auto x2ym = x.zip(y).map!"a[0]*a[0]*a[1]".average();

    auto sxx = x2m - xm * xm;
    auto sxy = xym - xm * ym;
    auto sxx2 = x3m - xm * x2m;
    auto sx2x2 = x4m - x2m * x2m;
    auto sx2y = x2ym - x2m * ym;

    auto b = (sxy * sx2x2 - sx2y * sxx2) / (sxx * sx2x2 - sxx2 * sxx2);
    auto c = (sx2y * sxx - sxy * sxx2) / (sxx * sx2x2 - sxx2 * sxx2);
    auto a = ym - b * xm - c * x2m;

    real abc(int xx) {
        return a + b * xx + c * xx * xx;
    }

    writeln("y = ", a, " + ", b, "x + ", c, "x^2");
    writeln(" Input  Approximation");
    writeln(" x   y     y1");
    foreach (i; 0..n) {
        writefln("%2d %3d  %5.1f", x[i], y[i], abc(x[i]));
    }
}

void main() {
    auto x = iota(0, 11).array;
    auto y = [1, 6, 17, 34, 57, 86, 121, 162, 209, 262, 321];
    polyRegression(x, y);
}
