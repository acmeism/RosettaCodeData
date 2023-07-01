using System;
using System.Linq;

namespace Luhn
{
    class Program
    {
        public static bool luhn(long n)
        {
            long nextdigit, sum = 0;
            bool alt = false;
            while (n != 0)
            {
                nextdigit = n % 10;
                if (alt)
                {
                    nextdigit *= 2;
                    nextdigit -= (nextdigit > 9) ? 9 : 0;
                }
                sum += nextdigit;
                alt = !alt;
                n /= 10;
            }
            return (sum % 10 == 0);
        }

        public static bool luhnLinq(long n)
        {
            string s = n.ToString();
            return s.Select((c, i) => (c - '0') << ((s.Length - i - 1) & 1)).Sum(n => n > 9 ? n - 9 : n) % 10 == 0;
        }

        static void Main(string[] args)
        {
            long[] given = new long[] {49927398716, 49927398717, 1234567812345678, 1234567812345670};
            foreach (long num in given)
            {
                string valid = (luhn(num)) ? " is valid" : " is not valid";
                Console.WriteLine(num + valid);
            }

        }
    }
}
