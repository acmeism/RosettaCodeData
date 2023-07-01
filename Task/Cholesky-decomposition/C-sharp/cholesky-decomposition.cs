using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Cholesky
{
    class Program
    {
        /// <summary>
        /// This is example is written in C#, and compiles with .NET Framework 4.0
        /// </summary>
        /// <param name="args"></param>
        static void Main(string[] args)
        {
            double[,] test1 = new double[,]
            {
                {25, 15, -5},
                {15, 18, 0},
                {-5, 0, 11},
            };

            double[,] test2 = new double[,]
            {
                {18, 22, 54, 42},
                {22, 70, 86, 62},
                {54, 86, 174, 134},
                {42, 62, 134, 106},
            };

            double[,] chol1 = Cholesky(test1);
            double[,] chol2 = Cholesky(test2);

            Console.WriteLine("Test 1: ");
            Print(test1);
            Console.WriteLine("");
            Console.WriteLine("Lower Cholesky 1: ");
            Print(chol1);
            Console.WriteLine("");
            Console.WriteLine("Test 2: ");
            Print(test2);
            Console.WriteLine("");
            Console.WriteLine("Lower Cholesky 2: ");
            Print(chol2);

        }

        public static void Print(double[,] a)
        {
            int n = (int)Math.Sqrt(a.Length);

            StringBuilder sb = new StringBuilder();
            for (int r = 0; r < n; r++)
            {
                string s = "";
                for (int c = 0; c < n; c++)
                {
                    s += a[r, c].ToString("f5").PadLeft(9) + ",";
                }
                sb.AppendLine(s);
            }

            Console.WriteLine(sb.ToString());
        }

        /// <summary>
        /// Returns the lower Cholesky Factor, L, of input matrix A.
        /// Satisfies the equation: L*L^T = A.
        /// </summary>
        /// <param name="a">Input matrix must be square, symmetric,
        /// and positive definite. This method does not check for these properties,
        /// and may produce unexpected results of those properties are not met.</param>
        /// <returns></returns>
        public static double[,] Cholesky(double[,] a)
        {
            int n = (int)Math.Sqrt(a.Length);

            double[,] ret = new double[n, n];
            for (int r = 0; r < n; r++)
                for (int c = 0; c <= r; c++)
                {
                    if (c == r)
                    {
                        double sum = 0;
                        for (int j = 0; j < c; j++)
                        {
                            sum += ret[c, j] * ret[c, j];
                        }
                        ret[c, c] = Math.Sqrt(a[c, c] - sum);
                    }
                    else
                    {
                        double sum = 0;
                        for (int j = 0; j < c; j++)
                            sum += ret[r, j] * ret[c, j];
                        ret[r, c] = 1.0 / ret[c, c] * (a[r, c] - sum);
                    }
                }

            return ret;
        }
    }
}
