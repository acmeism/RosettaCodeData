//Narcissistic numbers: Nigel Galloway: February 17th., 2015
using System;
using System.Collections.Generic;
using System.Linq;

namespace RC {
    public static class NumberEx {
        public static IEnumerable<int> Digits(this int n) {
            List<int> digits = new List<int>();
            while (n > 0) {
                digits.Add(n % 10);
                n /= 10;
            }
            return digits.AsEnumerable();
        }
    }

    class Program {
        static void Main(string[] args) {
            foreach (int N in Enumerable.Range(0, Int32.MaxValue).Where(k => {
                var digits = k.Digits();
                return digits.Sum(x => Math.Pow(x, digits.Count())) == k;
            }).Take(25)) {
                System.Console.WriteLine(N);
            }
        }
    }
}
