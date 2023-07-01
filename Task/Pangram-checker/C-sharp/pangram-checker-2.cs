using System;

namespace PangrammChecker
{
    public class PangrammChecker
    {
        public static bool IsPangram(string str)
        {
            bool[] isUsed = new bool[26];
            int ai = (int)'a';
            int total = 0;
            for (CharEnumerator en = str.ToLower().GetEnumerator(); en.MoveNext(); )
            {
                int d = (int)en.Current - ai;
                if (d >= 0 && d < 26)
                    if (!isUsed[d])
                    {
                        isUsed[d] = true;
                        total++;
                    }
            }
            return (total == 26);
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            string str1 = "The quick brown fox jumps over the lazy dog.";
            string str2 = "The qu1ck brown fox jumps over the lazy d0g.";
            Console.WriteLine("{0} is {1}a pangram", str1,
                PangrammChecker.IsPangram(str1)?"":"not ");
            Console.WriteLine("{0} is {1}a pangram", str2,
                PangrammChecker.IsPangram(str2)?"":"not ");
            Console.WriteLine("Press Return to exit");
            Console.ReadLine();
        }
    }
}
