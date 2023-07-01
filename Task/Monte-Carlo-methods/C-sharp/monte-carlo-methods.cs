using System;

class Program {
    static double MonteCarloPi(int n) {
        int inside = 0;
        Random r = new Random();

        for (int i = 0; i < n; i++) {
            if (Math.Pow(r.NextDouble(), 2)+ Math.Pow(r.NextDouble(), 2) <= 1) {
                inside++;
            }
        }

        return 4.0 * inside / n;
    }

    static void Main(string[] args) {
        int value = 1000;
        for (int n = 0; n < 5; n++) {
            value *= 10;
            Console.WriteLine("{0}:{1}", value.ToString("#,###").PadLeft(11, ' '), MonteCarloPi(value));
        }
    }
}
