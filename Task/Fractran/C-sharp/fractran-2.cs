    class Program
    {
        private static bool PowerOfTwo(BigInteger b)
        {
            while (b % 2 == 0)
                b /= 2;
            return b == 1;
        }

        private static BigInteger BigLog2(BigInteger b)
        {
            BigInteger r = 0;
            while (b > 1)
            {
                r++;
                b /= 2;
            }
            return r;
        }

        public static void Main(string[] args)
        {
            Fractype[] frac_code = args[0].Split(" ")
                .Select(x => ((BigInteger)Int32.Parse(x.Split("/")[0]), (BigInteger)Int32.Parse(x.Split("/")[1].Trim(',')))).ToArray();
            BigInteger init = new BigInteger(Int32.Parse(args[1].Trim(',')));
            int steps = Int32.Parse(args[2].Trim(','));

            FRACTRAN FRACGAME = new FRACTRAN(frac_code);

            List<BigInteger> sequence = new List<BigInteger>();
            List<BigInteger> primes = new List<BigInteger>();
            sequence.Add(init);
            bool halt = false;
            while (primes.Count() < 20)
            {
                var k = FRACGAME.Compute(sequence[sequence.Count - 1]);
                if (k.success)
                    sequence.Add(k.value);
                else
                {
                    halt = true;
                    break;
                }

                if (PowerOfTwo(k.value))
                    primes.Add(BigLog2(k.value));
            }

            for (int i = 0; i < primes.Count; i++)
                Console.WriteLine((i + 1).ToString() + ": " + primes[i]);
            if (halt)
                Console.WriteLine("HALT");
        }
    }
