using System;
using MathNet.Numerics.LinearRegression;
using MathNet.Numerics.LinearAlgebra;
using MathNet.Numerics.LinearAlgebra.Double;

class Program
{
    static void Main(string[] args)
    {
        var col = DenseVector.OfArray(new double[] { 1.47, 1.50, 1.52, 1.55, 1.57, 1.60, 1.63, 1.65,
            1.68, 1.70, 1.73, 1.75, 1.78, 1.80, 1.83 });
        var X = DenseMatrix.OfColumns(new Vector<double>[] { col.PointwisePower(0), col, col.PointwisePower(2) });
        var y = DenseVector.OfArray(new double[] { 52.21, 53.12, 54.48, 55.84, 57.20, 58.57, 59.93,
            61.29, 63.11, 64.47, 66.28, 68.10, 69.92, 72.19, 74.46 });
        var β = MultipleRegression.QR(X, y);
        Console.WriteLine(β);
    }
}
