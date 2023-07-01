using System;

namespace Rosetta
{
    class Program
    {
        static void Main(string[] args)
        {
            Matrix M = new Matrix(4, 4, new double[] { -1, -2, 3, 2, -4, -1, 6, 2, 7, -8, 9, 1, 1, -2, 1, 3 });
            M.InvPartial();
            M.print();
        }
    }
}
