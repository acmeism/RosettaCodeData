using System;

namespace Narcissistic
{
    class Narcissistic
    {
        public bool isNarcissistic(int z)
        {
            if (z < 0) return false;
            string n = z.ToString();
            int t = 0, l = n.Length;
            foreach (char c in n)
                t += Convert.ToInt32(Math.Pow(Convert.ToDouble(c - 48), l));

            return t == z;
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            Narcissistic n = new Narcissistic();
            int c = 0, x = 0;
            while (c < 25)
            {
                if (n.isNarcissistic(x))
                {
                    if (c % 5 == 0) Console.WriteLine();
                    Console.Write("{0,7} ", x);
                    c++;
                }
                x++;
            }
            Console.WriteLine("\n\nPress any key to continue...");
            Console.ReadKey();
        }
    }
}
