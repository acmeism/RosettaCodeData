using System;

class Program
{
    static void Main()
    {
        string input = Console.ReadLine();
        int index = input.IndexOf(" ");
        int num1 = int.Parse(input.Substring(0, index));
        int num2 = int.Parse(input.Substring(index + 1));
        int sum = num1 + num2;
        Console.WriteLine(sum.ToString());
    }
}
