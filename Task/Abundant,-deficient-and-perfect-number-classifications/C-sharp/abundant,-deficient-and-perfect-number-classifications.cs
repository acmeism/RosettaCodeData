using System;
using System.Linq;

public class Program
{
    public static void Main()
    {
        int abundant, deficient, perfect;
        ClassifyNumbers.UsingSieve(20000, out abundant, out deficient, out perfect);
        Console.WriteLine($"Abundant: {abundant}, Deficient: {deficient}, Perfect: {perfect}");

        ClassifyNumbers.UsingDivision(20000, out abundant, out deficient, out perfect);
        Console.WriteLine($"Abundant: {abundant}, Deficient: {deficient}, Perfect: {perfect}");
    }
}

public static class ClassifyNumbers
{
    //Fastest way
    public static void UsingSieve(int bound, out int abundant, out int deficient, out int perfect) {
        int a = 0, d = 0, p = 0;
        //For very large bounds, this array can get big.
        int[] sum = new int[bound + 1];
        for (int divisor = 1; divisor <= bound / 2; divisor++) {
            for (int i = divisor + divisor; i <= bound; i += divisor) {
                sum[i] += divisor;
            }
        }
        for (int i = 1; i <= bound; i++) {
            if (sum[i] < i) d++;
            else if (sum[i] > i) a++;
            else p++;
        }
        abundant = a;
        deficient = d;
        perfect = p;
    }

    //Much slower, but doesn't use storage
    public static void UsingDivision(int bound, out int abundant, out int deficient, out int perfect) {
        int a = 0, d = 0, p = 0;
        for (int i = 1; i < 20001; i++) {
            int sum = Enumerable.Range(1, (i + 1) / 2)
                .Where(div => div != i && i % div == 0).Sum();
            if (sum < i) d++;
            else if (sum > i) a++;
            else p++;
        }
        abundant = a;
        deficient = d;
        perfect = p;
    }
}
