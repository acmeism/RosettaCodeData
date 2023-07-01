using System;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;

namespace HammingTest
{
    class HammingNode
    {
        public double log;
        public int[] exponents;
        public HammingNode next;
        public int series;
    }

    class HammingListEnumerator : IEnumerable<BigInteger>
    {
        private int[] primes;
        private double[] primelogs;
        private HammingNode next;
        private HammingNode[] values;
        private HammingNode[] indexes;

        public HammingListEnumerator(IEnumerable<int> seeds)
        {
            // Ensure our seeds are properly ordered, and generate their log values
            primes = seeds.OrderBy(x => x).ToArray();
            primelogs = primes.Select(x => Math.Log10(x)).ToArray();
            // Start at 1 (log(1)=0, exponents are all 0, series = none)
            next = new HammingNode { log = 0, exponents = new int[primes.Length], series = primes.Length };
            // Set all exponent sequences to the start, and calculate the first value for each exponent
            indexes = new HammingNode[primes.Length];
            values = new HammingNode[primes.Length];
            for(int i = 0; i < primes.Length; ++i)
            {
                indexes[i] = next;
                values[i] = AddExponent(next, i);
            }
        }

        // Make a copy of a node, and increment the specified exponent value
        private HammingNode AddExponent(HammingNode node, int i)
        {
            HammingNode ret = new HammingNode { log = node.log + primelogs[i], exponents = (int[])node.exponents.Clone(), series = i };
            ++ret.exponents[i];
            return ret;
        }

        private void GetNext()
        {
            // Find which exponent value is the lowest
            int min = 0;
            for(int i = 1; i < values.Length; ++i)
                if(values[i].log < values[min].log)
                    min = i;

            // Add it to the end of the 'list', and move to it
            next.next = values[min];
            next = values[min];

            // Find the next node in an allowed sequence (skip those that would be duplicates)
            HammingNode val = indexes[min].next;
            while(val.series < min)
                val = val.next;

            // Keep the current index, and calculate the next value in the series for that exponent
            indexes[min] = val;
            values[min] = AddExponent(val, min);
        }

        // Skip values without having to calculate the BigInteger value from the exponents
        public HammingListEnumerator Skip(int count)
        {
            for(int i = count; i > 0; --i)
                GetNext();

            return this;
        }

        // Calculate the BigInteger value from the exponents
        internal BigInteger ValueOf(HammingNode n)
        {
            BigInteger val = 1;
            for(int i = 0; i < n.exponents.Length; ++i)
                for(int e = 0; e < n.exponents[i]; e++)
                    val = val * primes[i];
            return val;
        }

        public IEnumerator<BigInteger> GetEnumerator()
        {
            while(true)
            {
                yield return ValueOf(next);
                GetNext();
            }
        }

        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator()
        {
            return this.GetEnumerator();
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            foreach(int[] primes in new int[][] {
                new int[] { 2, 3, 5 },
                new int[] { 2, 3, 5, 7 },
                new int[] { 2, 3, 5, 7, 9}})
            {
                HammingListEnumerator hammings = new HammingListEnumerator(primes);
                System.Diagnostics.Debug.WriteLine("{0}-Smooth:", primes.Last());
                System.Diagnostics.Debug.WriteLine(String.Join(" ", hammings.Take(20).ToArray()));
                System.Diagnostics.Debug.WriteLine(hammings.Skip(1691 - 20).First());
                System.Diagnostics.Debug.WriteLine(hammings.Skip(1000000 - 1691).First());
                System.Diagnostics.Debug.WriteLine("");
            }
        }
    }
}
