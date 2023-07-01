void main() {
    import std.stdio, std.algorithm;

    double[3] a = [1.0, 3.0, -5.0];
    double[3] b = [4.0, -2.0, -1.0];
    double[3] c = a[] * b[];
    c[].sum.writeln;
}
