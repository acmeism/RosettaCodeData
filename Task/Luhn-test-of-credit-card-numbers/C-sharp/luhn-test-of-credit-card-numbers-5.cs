using System;
using EuropaRTL.Utilities;

public static partial class Algoritmhs
{
    public static bool CheckLuhn(long n)
    {
        int s1 = n.Shatter(true).Subset(2).Arithmetic('+');
        int s2 = n.Shatter(true).Subset(1, -1, 2).ArithmeticRA('*', 2).ShatterAndSum().Arithmetic('+');
        return (s1 + s2) % 10 == 0 ? true : false;
    }
}
class Program
{
    static void Main(string[] args)
    {
        long[] ll = {
                49927398716,
                49927398717,
                1234567812345678,
                1234567812345670
            };
        foreach (var item in ll)
        {
            item.ToString().WriteLine();
            Algoritmhs.CheckLuhn(item).ToString().WriteLine();
        }
        Console.ReadKey();
    }
}
