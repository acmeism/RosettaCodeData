using System;

class JensensDevice
{
    public static double Sum(ref int i, int lo, int hi, Func<double> term)
    {
        double temp = 0.0;
        for (i = lo; i <= hi; i++)
        {
            temp += term();
        }
        return temp;
    }

    static void Main()
    {
        int i = 0;
        Console.WriteLine(Sum(ref i, 1, 100, () => 1.0 / i));
    }
}
