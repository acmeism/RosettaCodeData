using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Hailstone
{
    class Program
    {
        public static List<int> hs(int n,List<int> seq)
        {
            List<int> sequence = seq;
            sequence.Add(n);
            if (n == 1)
            {
                return sequence;
            }else{
                int newn = (n % 2 == 0) ? n / 2 : (3 * n) + 1;
                return hs(newn, sequence);
            }
        }

        static void Main(string[] args)
        {
            int n = 27;
            List<int> sequence = hs(n,new List<int>());
            Console.WriteLine(sequence.Count + " Elements");
            List<int> start = sequence.GetRange(0, 4);
            List<int> end = sequence.GetRange(sequence.Count - 4, 4);
            Console.WriteLine("Starting with : " + string.Join(",", start) + " and ending with : " + string.Join(",", end));
            int number = 0, longest = 0;
            for (int i = 1; i < 100000; i++)
            {
                int count = (hs(i, new List<int>())).Count;
                if (count > longest)
                {
                    longest = count;
                    number = i;
                }
            }
            Console.WriteLine("Number < 100000 with longest Hailstone seq.: " + number + " with length of " + longest);
       }
    }
}
