using System;
using System.Collections.Generic;
using System.Linq;

public class FindPalindromicNumbers
{
    static void Main(string[] args)
    {
        var query =
            PalindromicTernaries()
            .Where(IsPalindromicBinary)
            .Take(6);
        foreach (var x in query) {
            Console.WriteLine("Decimal: " + x);
            Console.WriteLine("Ternary: " + ToTernary(x));
            Console.WriteLine("Binary: " + Convert.ToString(x, 2));
            Console.WriteLine();
        }
    }

    public static IEnumerable<long> PalindromicTernaries() {
        yield return 0;
        yield return 1;
        yield return 13;
        yield return 23;

        var f = new List<long> {0};
        long fMiddle = 9;
        while (true) {
            for (long edge = 1; edge < 3; edge++) {
                int i;
                do {
                    //construct the result
                    long result = fMiddle;
                    long fLeft = fMiddle * 3;
                    long fRight = fMiddle / 3;
                    for (int j = f.Count - 1; j >= 0; j--) {
                        result += (fLeft + fRight) * f[j];
                        fLeft *= 3;
                        fRight /= 3;
                    }
                    result += (fLeft + fRight) * edge;
                    yield return result;

                    //next permutation
                    for (i = f.Count - 1; i >= 0; i--) {
                        if (f[i] == 2) {
                            f[i] = 0;
                        } else {
                            f[i]++;
                            break;
                        }
                    }
                } while (i >= 0);
            }
            f.Add(0);
            fMiddle *= 3;
        }
    }

    public static bool IsPalindromicBinary(long number) {
        long n = number;
        long reverse = 0;
        while (n != 0) {
            reverse <<= 1;
            if ((n & 1) == 1) reverse++;
            n >>= 1;
        }
        return reverse == number;
    }

    public static string ToTernary(long n)
    {
        if (n == 0) return "0";
        string result = "";
        while (n > 0) {        {
            result = (n % 3) + result;
            n /= 3;
        }
        return result;
    }

}
