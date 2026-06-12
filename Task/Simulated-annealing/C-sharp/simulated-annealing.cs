using System;
using System.Collections.Generic;
using System.Linq;

public class SimulatedAnnealingTSP
{
    private static readonly double[] dists = CalcDists();
    private static readonly int[] dirs = {1, -1, 10, -10, 9, 11, -11, -9}; // all 8 neighbors
    private static readonly Random rand = new Random();

    // distances
    private static double[] CalcDists()
    {
        double[] dists = new double[10000];
        for (int i = 0; i < 10000; i++)
        {
            double ab = Math.Floor(i / 100.0);
            double cd = i % 100;
            double a = Math.Floor(ab / 10);
            double b = (int)ab % 10;
            double c = Math.Floor(cd / 10);
            double d = (int)cd % 10;
            dists[i] = Math.Sqrt(Math.Pow(a - c, 2) + Math.Pow(b - d, 2));
        }
        return dists;
    }

    // index into lookup table of doubles
    private static double Dist(int ci, int cj)
    {
        return dists[cj * 100 + ci];
    }

    // energy at s, to be minimized
    private static double Es(int[] path)
    {
        double d = 0.0;
        for (int i = 0; i < path.Length - 1; i++)
        {
            d += Dist(path[i], path[i + 1]);
        }
        return d;
    }

    // temperature function, decreases to 0
    private static double T(int k, int kmax, int kT)
    {
        return (1 - (double)k / kmax) * kT;
    }

    // variation of E, from state s to state s_next
    private static double DE(int[] s, int u, int v)
    {
        int su = s[u], sv = s[v];
        // old
        double a = Dist(s[u - 1], su);
        double b = Dist(s[u + 1], su);
        double c = Dist(s[v - 1], sv);
        double d = Dist(s[v + 1], sv);
        // new
        double na = Dist(s[u - 1], sv);
        double nb = Dist(s[u + 1], sv);
        double nc = Dist(s[v - 1], su);
        double nd = Dist(s[v + 1], su);

        if (v == u + 1)
        {
            return (na + nd) - (a + d);
        }
        else if (u == v + 1)
        {
            return (nc + nb) - (c + b);
        }
        else
        {
            return (na + nb + nc + nd) - (a + b + c + d);
        }
    }

    // probability to move from s to s_next
    private static double P(double deltaE, int k, int kmax, int kT)
    {
        return Math.Exp(-deltaE / T(k, kmax, kT));
    }

    public static void SA(int kmax, int kT)
    {
        //rand.SetSeed((int)DateTime.Now.Ticks);

        // Create temp list with values 1 to 99
        List<int> temp = new List<int>();
        for (int i = 0; i < 99; i++)
        {
            temp.Add(i + 1);
        }

        // Shuffle the list
        for (int i = temp.Count - 1; i > 0; i--)
        {
            int j = rand.Next(i + 1);
            int value = temp[j];
            temp[j] = temp[i];
            temp[i] = value;
        }

        // Initialize path array
        int[] s = new int[101]; // all 0 by default
        for (int i = 0; i < 99; i++)
        {
            s[i + 1] = temp[i]; // random path from 0 to 0
        }

        Console.WriteLine("kT = " + kT);
        Console.WriteLine($"E(s0) {Es(s):F6}\n");

        double Emin = Es(s); // E0

        for (int k = 0; k <= kmax; k++)
        {
            if (k % (kmax / 10) == 0)
            {
                Console.WriteLine($"k:{k,10}   T: {T(k, kmax, kT),8:F4}   Es: {Es(s),8:F4}");
            }

            int u = 1 + rand.Next(99); // city index 1 to 99
            int cv = s[u] + dirs[rand.Next(8)]; // city number

            if (cv <= 0 || cv >= 100) // bogus city
            {
                continue;
            }

            if (Dist(s[u], cv) > 5) // check true neighbor (eg 0 9)
            {
                continue;
            }

            int v = s[cv]; // city index
            double deltae = DE(s, u, v);

            if (deltae < 0 || // always move if negative
                P(deltae, k, kmax, kT) >= rand.NextDouble())
            {
                // Swap s[u] and s[v]
                int tempVal = s[u];
                s[u] = s[v];
                s[v] = tempVal;
                Emin += deltae;
            }
        }

        Console.WriteLine($"\nE(s_final) {Emin:F6}");
        Console.WriteLine("Path:");

        // output final state
        for (int i = 0; i < s.Length; i++)
        {
            if (i > 0 && i % 10 == 0)
            {
                Console.WriteLine();
            }
            Console.Write($"{s[i],4}");
        }
        Console.WriteLine();
    }

    public static void Main(string[] args)
    {
        SA(1000000, 1);
    }
}
