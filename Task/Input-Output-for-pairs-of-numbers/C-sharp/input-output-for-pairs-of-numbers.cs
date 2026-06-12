using System;
using static System.Linq.Enumerable;

public class Program
{
    static void Main(string[] args)
    {
	int count = Convert.ToInt32(Console.ReadLine());
	for (int line = 0; line < count; line++) {
            Console.WriteLine(Console.ReadLine().Split(' ').Sum(i => Convert.ToInt32(i)));
	}
    }
}
