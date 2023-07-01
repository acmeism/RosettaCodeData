using System;

namespace LCS
{
    class Program
    {
        static void Main(string[] args)
        {
            string word1 = "thisisatest";
            string word2 = "testing123testing";

            Console.WriteLine(lcsBack(word1, word2));
            Console.ReadKey();
        }

        public static string lcsBack(string a, string b)
        {
            string aSub = a.Substring(0, (a.Length - 1 < 0) ? 0 : a.Length - 1);
            string bSub = b.Substring(0, (b.Length - 1 < 0) ? 0 : b.Length - 1);

            if (a.Length == 0 || b.Length == 0)
                return "";
            else if (a[a.Length - 1] == b[b.Length - 1])
                return lcsBack(aSub, bSub) + a[a.Length - 1];
            else
            {
                string x = lcsBack(a, bSub);
                string y = lcsBack(aSub, b);
                return (x.Length > y.Length) ? x : y;
            }
        }
    }
}
