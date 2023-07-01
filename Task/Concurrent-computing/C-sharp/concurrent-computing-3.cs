using System;
using System.Threading.Tasks;

public class Program
{
    static void Main() => Parallel.ForEach(new[] {"Enjoy", "Rosetta", "Code"}, s => Console.WriteLine(s));
}
