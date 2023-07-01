using System.Collections.Generic;

namespace PrimeDecomposition
{
    public class Primes
    {
        public List<int> FactorsOf(int n)
        {
            var factors = new List<int>();

            for (var divisor = 2; n > 1; divisor++)
                for (; n % divisor == 0; n /= divisor)
                    factors.Add(divisor);

            return factors;
        }
}
