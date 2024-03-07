using System;

public class MagicConstant {

    private const int OrderFirstMagicSquare = 3;

    public static void Main(string[] args) {
        Console.WriteLine("The first 20 magic constants:");
        for (int i = 1; i <= 20; i++) {
            Console.Write(" " + MagicConstantValue(Order(i)));
        }
        Console.WriteLine("\n");

        Console.WriteLine("The 1,000th magic constant: " + MagicConstantValue(Order(1_000)) + "\n");

        Console.WriteLine("Order of the smallest magic square whose constant is greater than:");
        for (int i = 1; i <= 20; i++) {
            string powerOf10 = "10^" + i + ":";
            Console.WriteLine($"{powerOf10,6}{MinimumOrder(i),8}");
        }
    }

    // Return the magic constant for a magic square of the given order
    private static int MagicConstantValue(int n) {
        return n * (n * n + 1) / 2;
    }

    // Return the smallest order of a magic square such that its magic constant is greater than 10 to the given power
    private static int MinimumOrder(int n) {
        return (int)Math.Exp((Math.Log(2.0)+ n * Math.Log(10.0)) / 3) + 1;
    }

    // Return the order of the magic square at the given index
    private static int Order(int index) {
        return OrderFirstMagicSquare + index - 1;
    }
}
