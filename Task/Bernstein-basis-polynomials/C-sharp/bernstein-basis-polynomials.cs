using System;

class Program
{
    static double[] ToBern2(double[] a)
    {
        return new double[] { a[0], a[0] + a[1] / 2, a[0] + a[1] + a[2] };
    }

    static double EvalBern2(double[] b, double t)
    {
        double s = 1.0 - t;
        double b01 = s * b[0] + t * b[1];
        double b12 = s * b[1] + t * b[2];
        return s * b01 + t * b12;
    }

    static double[] ToBern3(double[] a)
    {
        return new double[] { a[0], a[0] + a[1] / 3, a[0] + a[1] * 2 / 3 + a[2] / 3, a[0] + a[1] + a[2] + a[3] };
    }

    static double EvalBern3(double[] b, double t)
    {
        double s = 1.0 - t;
        double b01 = s * b[0] + t * b[1];
        double b12 = s * b[1] + t * b[2];
        double b23 = s * b[2] + t * b[3];
        double b012 = s * b01 + t * b12;
        double b123 = s * b12 + t * b23;
        return s * b012 + t * b123;
    }

    static double[] Bern2To3(double[] q)
    {
        return new double[] { q[0], q[0] / 3 + q[1] * 2 / 3, q[1] * 2 / 3 + q[2] / 3, q[2] };
    }

    static double EvalMono2(double[] a, double t)
    {
        return a[0] + (t * (a[1] + (t * a[2])));
    }

    static double EvalMono3(double[] a, double t)
    {
        return a[0] + (t * (a[1] + (t * (a[2] + (t * a[3])))));
    }

    static void Main(string[] args)
    {
        double[] pm = { 1, 0, 0 };
        double[] qm = { 1, 2, 3 };
        double[] rm = { 1, 2, 3, 4 };
        double x, y, m;

        Console.WriteLine("Subprogram(1) examples:");
        var pb2 = ToBern2(pm);
        var qb2 = ToBern2(qm);
        Console.WriteLine($"mono [{string.Join(", ", pm)}] --> bern [{string.Join(", ", pb2)}]");
        Console.WriteLine($"mono [{string.Join(", ", qm)}] --> bern [{string.Join(", ", qb2)}]");

        Console.WriteLine("\nSubprogram(2) examples:");
        x = 0.25;
        y = EvalBern2(pb2, x);
        m = EvalMono2(pm, x);
        Console.WriteLine($"p({x:F2}) = {y:G14} (mono {m:G14})");
        x = 7.5;
        y = EvalBern2(pb2, x);
        m = EvalMono2(pm, x);
        Console.WriteLine($"p({x:F2}) = {y:G14} (mono {m:G14})");

        x = 0.25;
        y = EvalBern2(qb2, x);
        m = EvalMono2(qm, x);
        Console.WriteLine($"q({x:F2}) = {y:G14} (mono {m:G14})");
        x = 7.5;
        y = EvalBern2(qb2, x);
        m = EvalMono2(qm, x);
        Console.WriteLine($"q({x:F2}) = {y:G14} (mono {m:G14})");

        Console.WriteLine("\nSubprogram(3) examples:");
        var pb3 = ToBern3(new double[] { pm[0], pm[1], pm[2], 0 });
        var qb3 = ToBern3(new double[] { qm[0], qm[1], qm[2], 0 });
        var rb3 = ToBern3(rm);
        Console.WriteLine($"mono [{string.Join(", ", pm)}] --> bern [{string.Join(", ", pb3)}]");
        Console.WriteLine($"mono [{string.Join(", ", qm)}] --> bern [{string.Join(", ", qb3)}]");
        Console.WriteLine($"mono [{string.Join(", ", rm)}] --> bern [{string.Join(", ", rb3)}]");

        Console.WriteLine("\nSubprogram(4) examples:");
        x = 0.25;
        y = EvalBern3(pb3, x);
        m = EvalMono3(new double[] { pm[0], pm[1], pm[2], 0 }, x);
        Console.WriteLine($"p({x:F2}) = {y:G14} (mono {m:G14})");
        x = 7.5;
        y = EvalBern3(pb3, x);
        m = EvalMono3(new double[] { pm[0], pm[1], pm[2], 0 }, x);
        Console.WriteLine($"p({x:F2}) = {y:G14} (mono {m:G14})");

        x = 0.25;
        y = EvalBern3(qb3, x);
        m = EvalMono3(new double[] { qm[0], qm[1], qm[2], 0 }, x);
        Console.WriteLine($"q({x:F2}) = {y:G14} (mono {m:G14})");
        x = 7.5;
        y = EvalBern3(qb3, x);
        m = EvalMono3(new double[] { qm[0], qm[1], qm[2], 0 }, x);
        Console.WriteLine($"q({x:F2}) = {y:G14} (mono {m:G14})");

        x = 0.25;
        y = EvalBern3(rb3, x);
        m = EvalMono3(rm, x);
        Console.WriteLine($"r({x:F2}) = {y:G14} (mono {m:G14})");
        x = 7.5;
        y = EvalBern3(rb3, x);
        m = EvalMono3(rm, x);
        Console.WriteLine($"r({x:F2}) = {y:G14} (mono {m:G14})");

        Console.WriteLine("\nSubprogram(5) examples:");
        var pc = Bern2To3(pb2);
        var qc = Bern2To3(qb2);
        Console.WriteLine($"bern [{string.Join(", ", pb2)}] --> bern3 [{string.Join(", ", pc)}]");
        Console.WriteLine($"bern [{string.Join(", ", qb2)}] --> bern3 [{string.Join(", ", qc)}]");
    }
}
