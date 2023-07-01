using System.IO;

class Program
{
    static void Main(string[] args)
    {
        var x = new double[] { 1, 2, 3, 1e11 };
        var y = new double[] { 1, 1.4142135623730951, 1.7320508075688772, 316227.76601683791 };

        int xprecision = 3;
        int yprecision = 5;

        string formatString = "{0:G" + xprecision + "}\t{1:G" + yprecision + "}";

        using (var outf = new StreamWriter("FloatArrayColumns.txt"))
            for (int i = 0; i < x.Length; i++)
                outf.WriteLine(formatString, x[i], y[i]);
    }
}
