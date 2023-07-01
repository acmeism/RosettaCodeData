static double r5 = Math.Sqrt(5.0), Phi = (r5 + 1.0) / 2.0;

static ulong fib(uint n) {
    if (n > 71) throw new ArgumentOutOfRangeException("n", n, "Needs to be smaller than 72.");
    double r = Math.Pow(Phi, n) / r5;
    return (ulong)(n < 64 ? Math.Round(r) : Math.Floor(r)); }
