using System;

class Program
{
    static void Main(string[] args)
    {
        string testString = "test";
        Console.WriteLine(testString.Substring(1));
        Console.WriteLine(testString.Substring(0, testString.Length - 1));
        Console.WriteLine(testString.Substring(1, testString.Length - 2));
    }
}
