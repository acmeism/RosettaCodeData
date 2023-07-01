using System;
using MathNet.Numerics.LinearAlgebra;
using MathNet.Numerics.LinearAlgebra.Double;


class Program
{

    static void Main(string[] args)
    {
        Matrix<double> A = DenseMatrix.OfArray(new double[,]
        {
                {  12,  -51,    4 },
                {   6,  167,  -68 },
                {  -4,   24,  -41 }
        });
        Console.WriteLine("A:");
        Console.WriteLine(A);
        var qr = A.QR();
        Console.WriteLine();
        Console.WriteLine("Q:");
        Console.WriteLine(qr.Q);
        Console.WriteLine();
        Console.WriteLine("R:");
        Console.WriteLine(qr.R);
    }
}
