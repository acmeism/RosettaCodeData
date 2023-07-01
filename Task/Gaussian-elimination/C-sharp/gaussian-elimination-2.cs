using System;

namespace Rosetta
{
    class Program
    {
        static void Main(string[] args)
        {
            Matrix A = new Matrix(6, 6,
            new double[] {1.1,0.12,0.13,0.12,0.14,-0.12,
            1.21,0.63,0.39,0.25,0.16,0.1,
            1.03,1.26,1.58,1.98,2.49,3.13,
            1.06,1.88,3.55,6.7,12.62,23.8,
            1.12,2.51,6.32,15.88,39.9,100.28,
            1.16,3.14,9.87,31.01,97.41,306.02});
            Vector B = new Vector(new double[] { -0.01, 0.61, 0.91, 0.99, 0.60, 0.02 });
            A.ElimPartial(B);
            B.print();
        }
    }
}
