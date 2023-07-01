using System;
public static class IteratedDigitsSquaring
{
    public static void Main() {
        Console.WriteLine(Count89s(1_000_000));
        Console.WriteLine(Count89s(100_000_000));
    }

    public static int Count89s(int limit) {
        if (limit < 1) return 0;
        int[] end = new int[Math.Min(limit, 9 * 9 * 9 + 2)];
        int result = 0;

        for (int i = 1; i < end.Length; i++) {
            for (end[i] = i; end[i] != 1 && end[i] != 89; end[i] = SquareDigitSum(end[i])) { }
            if (end[i] == 89) result++;
        }
        for (int i = end.Length; i < limit; i++) {
            if (end[SquareDigitSum(i)] == 89) result++;
        }
        return result;

        int SquareDigitSum(int n) {
            int sum = 0;
            while (n > 0) {
                int digit = n % 10;
                sum += digit * digit;
                n /= 10;
            }
            return sum;
        }
    }

}
