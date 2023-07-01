using System;

class Program
{
    static void Main(string[] args)
    {
        var cube = new Func<double, double>(x => Math.Pow(x, 3.0));
        var croot = new Func<double, double>(x => Math.Pow(x, 1 / 3.0));

        var functionTuples = new[]
        {
            (forward: Math.Sin, backward: Math.Asin),
            (forward: Math.Cos, backward: Math.Acos),
            (forward: cube,     backward: croot)
        };

        foreach (var ft in functionTuples)
        {
            Console.WriteLine(ft.backward(ft.forward(0.5)));
        }
    }
}
