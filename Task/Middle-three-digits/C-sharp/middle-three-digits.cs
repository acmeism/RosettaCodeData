using System;

namespace RosettaCode
{
    class Program
    {
        static void Main(string[] args)
        {
            string text = Math.Abs(int.Parse(Console.ReadLine())).ToString();
            Console.WriteLine(text.Length < 2 || text.Length % 2 == 0 ? "Error" : text.Substring((text.Length - 3) / 2, 3));
        }
    }
}
