using System;

class KlarnerRadoSequence {

    static void Main(string[] args) {
        const int limit = 1_000_000;
        int[] klarnerRado = InitialiseKlarnerRadoSequence(limit);

        Console.WriteLine("The first 100 elements of the Klarner-Rado sequence:");
        for (int i = 1; i <= 100; i++) {
            Console.Write($"{klarnerRado[i],3}{(i % 10 == 0 ? "\n" : " ")}");
        }
        Console.WriteLine();

        int index = 1_000;
        while (index <= limit) {
            Console.WriteLine($"The {index}th element of Klarner-Rado sequence is {klarnerRado[index]}");
            index *= 10;
        }
    }

    private static int[] InitialiseKlarnerRadoSequence(int limit) {
        int[] result = new int[limit + 1];
        int i2 = 1, i3 = 1;
        int m2 = 1, m3 = 1;
        for (int i = 1; i <= limit; i++) {
            int minimum = Math.Min(m2, m3);
            result[i] = minimum;
            if (m2 == minimum) {
                m2 = result[i2] * 2 + 1;
                i2 += 1;
            }
            if (m3 == minimum) {
                m3 = result[i3] * 3 + 1;
                i3 += 1;
            }
        }
        return result;
    }
}
