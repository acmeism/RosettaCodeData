using System;

class DisariumNumbers {
    // Method to check if a number is a Disarium number
    public static bool IsDisarium(int num) {
        int n = num;
        int len = num.ToString().Length;
        int sum = 0;
        int i = 1;
        while (n > 0) {
            // C# does not support implicit conversion from double to int, so we explicitly convert the result of Math.Pow to int
            sum += (int)Math.Pow(n % 10, len - i + 1);
            n /= 10;
            i++;
        }
        return sum == num;
    }

    static void Main(string[] args) {
        int i = 0;
        int count = 0;
        // Find and print the first 19 Disarium numbers
        while (count <= 18) {
            if (IsDisarium(i)) {
                Console.Write($"{i} ");
                count++;
            }
            i++;
        }
        Console.WriteLine();
    }
}
