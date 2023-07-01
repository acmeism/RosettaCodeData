using System;
using System.Linq;
using static System.Math;
class Program
{
    static double MeanAngle(double[] angles)
    {
        var x = angles.Sum(a => Cos(a * PI / 180)) / angles.Length;
        var y = angles.Sum(a => Sin(a * PI / 180)) / angles.Length;
        return Atan2(y, x) * 180 / PI;
    }
    static void Main()
    {
        Action<double[]> printMean = x => Console.WriteLine("{0:0.###}", MeanAngle(x));
        printMean(new double[] { 350, 10 });
        printMean(new double[] { 90, 180, 270, 360 });
        printMean(new double[] { 10, 20, 30 });
    }
}
