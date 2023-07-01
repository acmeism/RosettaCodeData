using System;
using System.Linq;

public class Program
{
    public static void Main()
    {
        int abundant, deficient, perfect;
        var sw = System.Diagnostics.Stopwatch.StartNew();
        ClassifyNumbers.UsingSieve(20000, out abundant, out deficient, out perfect); sw.Stop();
        Console.WriteLine($"Abundant: {abundant}, Deficient: {deficient}, Perfect: {perfect}  {sw.Elapsed.TotalMilliseconds} ms");
        sw.Restart();
        ClassifyNumbers.UsingOptiDivision(20000, out abundant, out deficient, out perfect);
        Console.WriteLine($"Abundant: {abundant}, Deficient: {deficient}, Perfect: {perfect}  {sw.Elapsed.TotalMilliseconds} ms");
        sw.Restart();
        ClassifyNumbers.UsingDivision(20000, out abundant, out deficient, out perfect);
        Console.WriteLine($"Abundant: {abundant}, Deficient: {deficient}, Perfect: {perfect}  {sw.Elapsed.TotalMilliseconds} ms");
    }
}

public static class ClassifyNumbers
{
    //Fastest way, but uses memory
    public static void UsingSieve(int bound, out int abundant, out int deficient, out int perfect) {
        abundant = perfect = 0;
        //For very large bounds, this array can get big.
        int[] sum = new int[bound + 1];
        for (int divisor = 1; divisor <= bound >> 1; divisor++)
            for (int i = divisor << 1; i <= bound; i += divisor)
                sum[i] += divisor;
        for (int i = 1; i <= bound; i++) {
            if (sum[i] > i) abundant++;
            else if (sum[i] == i) perfect++;
        }
        deficient = bound - abundant - perfect;
    }

    //Slower, optimized, but doesn't use storage
    public static void UsingOptiDivision(int bound, out int abundant, out int deficient, out int perfect) {
        abundant = perfect = 0; int sum = 0;
        for (int i = 2, d, r = 1; i <= bound; i++) {
            if ((d = r * r - i) < 0) r++;
            for (int x = 2; x < r; x++) if (i % x == 0) sum += x + i / x;
            if (d == 0) sum += r;
            switch (sum.CompareTo(i)) { case 0: perfect++; break; case 1: abundant++; break; }
            sum = 1;
        }
        deficient = bound - abundant - perfect;
    }

    //Much slower, doesn't use storage and is un-optimized
    public static void UsingDivision(int bound, out int abundant, out int deficient, out int perfect) {
        abundant = perfect = 0;
        for (int i = 2; i <= bound; i++) {
            int sum = Enumerable.Range(1, (i + 1) / 2)
                .Where(div => i % div == 0).Sum();
            switch (sum.CompareTo(i)) {
                case 0: perfect++; break;
                case 1: abundant++; break;
            }
        }
        deficient = bound - abundant - perfect;
    }
}
