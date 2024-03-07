namespace System.Numerics
{
    using Fractype = (BigInteger numerator, BigInteger denominator);
    struct Quotient
    {
        private Fractype _frac;
        public Fractype Fraction
        {
            get => _frac;
            set => _frac = Reduce(value);
        }

        public bool IsIntegral => _frac.denominator == 1;

        public Quotient(BigInteger num, BigInteger den)
        {
            Fraction = (num, den);
        }

        public static BigInteger GCD(BigInteger a, BigInteger b)
        {
            return (b == 0) ? a : GCD(b, a % b);
        }

        private static Fractype Reduce(Fractype f)
        {
            if (f.denominator == 0)
                throw new DivideByZeroException();

            BigInteger gcd = Quotient.GCD(f.numerator, f.denominator);
            return (f.numerator / gcd, f.denominator / gcd);
        }

        public static Quotient operator *(Quotient a, Quotient b)
            => new Quotient(a._frac.numerator * b._frac.numerator, a._frac.denominator * b._frac.denominator);

        public static Quotient operator *(Quotient a, BigInteger n)
            => new Quotient(a._frac.numerator * n, a._frac.denominator);

        public static explicit operator Quotient(Fractype t) => new Quotient(t.numerator, t.denominator);
    }

    class FRACTRAN
    {
        private Quotient[] code;
        public FRACTRAN(Fractype[] _code)
        {
            code = _code.Select(x => (Quotient) x).ToArray();
        }

        public (BigInteger value, bool success) Compute(BigInteger n)
        {
            for (int i = 0; i < code.Length; i++)
                if ((code[i] * n).IsIntegral)
                    return ((code[i] * n).Fraction.numerator, true);
            return (0, false);
        }
    }

    class Program
    {
        public static void Main(string[] args)
        {
            Fractype[] frac_code = args[0].Split(" ")
                .Select(x => ((BigInteger)Int32.Parse(x.Split("/")[0]), (BigInteger)Int32.Parse(x.Split("/")[1].Trim(',')))).ToArray();
            BigInteger init = new BigInteger(Int32.Parse(args[1].Trim(',')));
            int steps = Int32.Parse(args[2].Trim(','));

            FRACTRAN FRACGAME = new FRACTRAN(frac_code);

            List<BigInteger> sequence = new List<BigInteger>();
            sequence.Add(init);
            bool halt = false;
            for (int i = 0; i < steps - 1; i++)
            {
                var k = FRACGAME.Compute(sequence[sequence.Count - 1]);
                if (k.success)
                    sequence.Add(k.value);
                else
                {
                    halt = true;
                    break;
                }
            }

            for (int i = 0; i < sequence.Count; i++)
                Console.WriteLine((i + 1).ToString() + ": " + sequence[i]);
            if (halt)
                Console.WriteLine("HALT");
        }
    }
}
