using System;

public class GoldenRatio {
    static void Iterate() {
        double oldPhi = 1.0, phi = 1.0, limit = 1e-5;
        int iters = 0;
        while (true) {
            phi = 1.0 + 1.0 / oldPhi;
            iters++;
            if (Math.Abs(phi - oldPhi) <= limit) break;
            oldPhi = phi;
        }
        Console.WriteLine($"Final value of phi : {phi:0.00000000000000}");
        double actualPhi = (1.0 + Math.Sqrt(5.0)) / 2.0;
        Console.WriteLine($"Number of iterations : {iters}");
        Console.WriteLine($"Error (approx) : {phi - actualPhi:0.00000000000000}");
    }

    public static void Main(string[] args) {
        Iterate();
    }
}
