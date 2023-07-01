using System;

public static class Program
{
    public static void Main() {
        Test(100000000000000.01, 100000000000000.011);
        Test(100.01, 100.011);
        Test(10000000000000.001 / 10000.0, 1000000000.0000001000);
        Test(0.001, 0.0010000001);
        Test(0.000000000000000000000101, 0.0);
        Test(Math.Sqrt(2) * Math.Sqrt(2), 2.0);
        Test(-Math.Sqrt(2) * Math.Sqrt(2), -2.0);
        Test(3.14159265358979323846, 3.14159265358979324);

        void Test(double a, double b) {
            const double epsilon = 1e-18;
            WriteLine($"{a}, {b} => {a.ApproxEquals(b, epsilon)}");
        }
    }

    public static bool ApproxEquals(this double value, double other, double epsilon) => Math.Abs(value - other) < epsilon;
}
