using System;
using System.Numerics;

public class Program
{
    static void Main() {
        Complex e = Math.E;
        Complex i = Complex.ImaginaryOne;
        Complex π = Math.PI;
        Console.WriteLine(Complex.Pow(e, i * π) + 1);
    }
}
