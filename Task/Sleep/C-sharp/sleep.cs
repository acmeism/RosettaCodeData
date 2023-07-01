using System;
using System.Threading;

class Program
{
    static void Main(string[] args)
    {
        int sleep = Convert.ToInt32(Console.ReadLine());
        Console.WriteLine("Sleeping...");
        Thread.Sleep(sleep); //milliseconds
        Console.WriteLine("Awake!");
    }
}
