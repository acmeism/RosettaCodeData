using System;
using System.IO;

class Program
{
    static void Main(string[] args)
    {
        Console.WriteLine(new FileInfo("/input.txt").Length);
        Console.WriteLine(new FileInfo("input.txt").Length);
    }
}
