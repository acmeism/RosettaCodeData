using System;

namespace RosettaCode.CSharp
{
    class Program
    {
        static void Count_New_Triangle(ulong A, ulong B, ulong C, ulong Max_Perimeter, ref ulong Total_Cnt, ref ulong Primitive_Cnt)
        {
            ulong Perimeter = A + B + C;

            if (Perimeter <= Max_Perimeter)
            {
                Primitive_Cnt = Primitive_Cnt + 1;
                Total_Cnt = Total_Cnt + Max_Perimeter / Perimeter;
                Count_New_Triangle(A + 2 * C - 2 * B, 2 * A + 2 * C - B, 2 * A + 3 * C - 2 * B, Max_Perimeter, ref Total_Cnt, ref Primitive_Cnt);
                Count_New_Triangle(A + 2 * B + 2 * C, 2 * A + B + 2 * C, 2 * A + 2 * B + 3 * C, Max_Perimeter, ref Total_Cnt, ref Primitive_Cnt);
                Count_New_Triangle(2 * B + 2 * C - A, B + 2 * C - 2 * A, 2 * B + 3 * C - 2 * A, Max_Perimeter, ref Total_Cnt, ref Primitive_Cnt);
            }
        }

        static void Count_Pythagorean_Triples()
        {
            ulong T_Cnt, P_Cnt;

            for (int I = 1; I <= 8; I++)
            {
                T_Cnt = 0;
                P_Cnt = 0;
                ulong ExponentNumberValue = (ulong)Math.Pow(10, I);
                Count_New_Triangle(3, 4, 5, ExponentNumberValue, ref T_Cnt, ref P_Cnt);
                Console.WriteLine("Perimeter up to 10E" + I + " : " + T_Cnt + " Triples, " + P_Cnt + " Primitives");
            }
        }

        static void Main(string[] args)
        {
            Count_Pythagorean_Triples();
        }
    }
}
