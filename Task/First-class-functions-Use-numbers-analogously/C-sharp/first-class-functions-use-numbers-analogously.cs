using System;
using System.Linq;

class Program
{
    static void Main(string[] args)
    {
        double x, xi, y, yi, z, zi;
        x = 2.0;
        xi = 0.5;
        y = 4.0;
        yi = 0.25;
        z = x + y;
        zi = 1.0 / (x + y);

        var numlist = new[] { x, y, z };
        var numlisti = new[] { xi, yi, zi };
        var multiplied = numlist.Zip(numlisti, (n1, n2) =>
                       {
                           Func<double, double> multiplier = m => n1 * n2 * m;
                           return multiplier;
                       });

        foreach (var multiplier in multiplied)
            Console.WriteLine(multiplier(0.5));
    }
}
