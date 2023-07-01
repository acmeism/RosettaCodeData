using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace VanDerCorput
{
    /// <summary>
    /// Computes the Van der Corput sequence for any number base.
    /// The numbers in the sequence vary from zero to one, including zero but excluding one.
    /// The sequence possesses low discrepancy.
    /// Here are the first ten terms for bases 2 to 5:
    ///
    /// base 2:  0  1/2  1/4  3/4  1/8  5/8  3/8  7/8  1/16  9/16
    /// base 3:  0  1/3  2/3  1/9  4/9  7/9  2/9  5/9  8/9  1/27
    /// base 4:  0  1/4  1/2  3/4  1/16  5/16  9/16  13/16  1/8  3/8
    /// base 5:  0  1/5  2/5  3/5  4/5  1/25  6/25  11/25  16/25  21/25
    /// </summary>
    /// <see cref="http://rosettacode.org/wiki/Van_der_Corput_sequence"/>
    public class VanDerCorputSequence: IEnumerable<Tuple<long,long>>
    {
        /// <summary>
        /// Number base for the sequence, which must bwe two or more.
        /// </summary>
        public int Base { get; private set; }

        /// <summary>
        /// Maximum number of terms to be returned by iterator.
        /// </summary>
        public long Count { get; private set; }

        /// <summary>
        /// Construct a sequence for the given base.
        /// </summary>
        /// <param name="iBase">Number base for the sequence.</param>
        /// <param name="count">Maximum number of items to be returned by the iterator.</param>
        public VanDerCorputSequence(int iBase, long count = long.MaxValue) {
            if (iBase < 2)
                throw new ArgumentOutOfRangeException("iBase", "must be two or greater, not the given value of " + iBase);
            Base = iBase;
            Count = count;
        }

        /// <summary>
        /// Compute nth term in the Van der Corput sequence for the base specified in the constructor.
        /// </summary>
        /// <param name="n">The position in the sequence, which may be zero or any positive number.</param>
        /// This number is always an integral power of the base.</param>
        /// <returns>The Van der Corput sequence value expressed as a Tuple containing a numerator and a denominator.</returns>
        public Tuple<long,long> Compute(long n)
        {
            long p = 0, q = 1;
            long numerator, denominator;
            while (n != 0)
            {
                p = p * Base + (n % Base);
                q *= Base;
                n /= Base;
            }
            numerator = p;
            denominator = q;
            while (p != 0)
            {
                n = p;
                p = q % p;
                q = n;
            }
            numerator /= q;
            denominator /= q;
            return new Tuple<long,long>(numerator, denominator);
        }

        /// <summary>
        /// Compute nth term in the Van der Corput sequence for the given base.
        /// </summary>
        /// <param name="iBase">Base to use for the sequence.</param>
        /// <param name="n">The position in the sequence, which may be zero or any positive number.</param>
        /// <returns>The Van der Corput sequence value expressed as a Tuple containing a numerator and a denominator.</returns>
        public static Tuple<long, long> Compute(int iBase, long n)
        {
            var seq = new VanDerCorputSequence(iBase);
            return seq.Compute(n);
        }

        /// <summary>
        /// Iterate over the Van Der Corput sequence.
        /// The first value in the sequence is always zero, regardless of the base.
        /// </summary>
        /// <returns>A tuple whose items are the Van der Corput value given as a numerator and denominator.</returns>
        public IEnumerator<Tuple<long, long>> GetEnumerator()
        {
            long iSequenceIndex = 0L;
            while (iSequenceIndex < Count)
            {
                yield return Compute(iSequenceIndex);
                iSequenceIndex++;
            }
        }

        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator()
        {
            return GetEnumerator();
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            TestBasesTwoThroughFive();

            Console.WriteLine("Type return to continue...");
            Console.ReadLine();
        }

        static void TestBasesTwoThroughFive()
        {
            foreach (var seq in Enumerable.Range(2, 5).Select(x => new VanDerCorputSequence(x, 10))) // Just the first 10 elements of the each sequence
            {
                Console.Write("base " + seq.Base + ":");
                foreach(var vc in seq)
                    Console.Write(" " + vc.Item1 + "/" + vc.Item2);
                Console.WriteLine();
            }
        }
    }
}
