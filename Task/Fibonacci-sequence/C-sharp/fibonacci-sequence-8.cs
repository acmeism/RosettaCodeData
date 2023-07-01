static decimal Sqrt_dec(decimal x, decimal g) { decimal t, lg;
    do { t = x / g; lg = g; g = (t + g) / 2M; } while (lg != g);
    return g; }

static decimal Pow_dec (decimal bas, uint exp) {
    if (exp == 0) return 1M;
    decimal tmp = Pow_dec(bas, exp >> 1); tmp *= tmp;
    if ((exp & 1) == 1) tmp *= bas; return tmp; }

static decimal r5 = Sqrt_dec(5.0M, (decimal)Math.Sqrt(5.0)),
               Phi = (r5 + 1.0M) / 2.0M;

static ulong fib(uint n) {
    if (n > 93) throw new ArgumentOutOfRangeException("n", n, "Needs to be smaller than 94.");
    decimal r = Pow_dec(Phi, n) / r5;
    return (ulong)(n < 64 ? Math.Round(r) : Math.Floor(r)); }
