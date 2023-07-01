using System;
using System.Text;

namespace ThueMorse
{
    class Program
    {
        static void Main(string[] args)
        {
            Sequence(6);
        }

        public static void Sequence(int steps)
        {
            var sb1 = new StringBuilder("0");
            var sb2 = new StringBuilder("1");
            for (int i = 0; i < steps; i++)
            {
                var tmp = sb1.ToString();
                sb1.Append(sb2);
                sb2.Append(tmp);
            }
            Console.WriteLine(sb1);
            Console.ReadLine();
        }
    }
}
