using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Fibonacci
{
    class Program
    {
        static void Main(string[] args)
        {
            PrintNumberSequence("Fibonacci", GetNnacciNumbers(2, 10));
            PrintNumberSequence("Lucas", GetLucasNumbers(10));
            PrintNumberSequence("Tribonacci", GetNnacciNumbers(3, 10));
            PrintNumberSequence("Tetranacci", GetNnacciNumbers(4, 10));
            Console.ReadKey();
        }

        private static IList<ulong> GetLucasNumbers(int length)
        {
            IList<ulong> seedSequence = new List<ulong>() { 2, 1 };
            return GetFibLikeSequence(seedSequence, length);
        }

        private static IList<ulong> GetNnacciNumbers(int seedLength, int length)
        {
            return GetFibLikeSequence(GetNacciSeed(seedLength), length);
        }

        private static IList<ulong> GetNacciSeed(int seedLength)
        {
            IList<ulong> seedSquence = new List<ulong>() { 1 };

            for (uint i = 0; i < seedLength - 1; i++)
            {
                seedSquence.Add((ulong)Math.Pow(2, i));
            }

            return seedSquence;
        }

        private static IList<ulong> GetFibLikeSequence(IList<ulong> seedSequence, int length)
        {
            IList<ulong> sequence = new List<ulong>();

            int count = seedSequence.Count();

            if (length <= count)
            {
                sequence = seedSequence.Take((int)length).ToList();
            }
            else
            {
                sequence = seedSequence;

                for (int i = count; i < length; i++)
                {
                    ulong num = 0;

                    for (int j = 0; j < count; j++)
                    {
                        num += sequence[sequence.Count - 1 - j];
                    }

                    sequence.Add(num);
                }
            }

            return sequence;
        }

        private static void PrintNumberSequence(string Title, IList<ulong> numbersequence)
        {
            StringBuilder output = new StringBuilder(Title).Append("   ");

            foreach (long item in numbersequence)
            {
                output.AppendFormat("{0}, ", item);
            }

            Console.WriteLine(output.ToString());
        }
    }
}
