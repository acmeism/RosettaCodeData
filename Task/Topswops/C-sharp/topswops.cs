using System;

public class Topswops {
    static readonly int maxBest = 32;
    static int[] best;

    private static void TrySwaps(int[] deck, int f, int d, int n) {
        if (d > best[n])
            best[n] = d;

        for (int i = n - 1; i >= 0; i--) {
            if (deck[i] == -1 || deck[i] == i)
                break;
            if (d + best[i] <= best[n])
                return;
        }

        int[] deck2 = (int[])deck.Clone();
        for (int i = 1; i < n; i++) {
            int k = 1 << i;
            if (deck2[i] == -1) {
                if ((f & k) != 0)
                    continue;
            } else if (deck2[i] != i)
                continue;

            deck2[0] = i;
            for (int j = i - 1; j >= 0; j--)
                deck2[i - j] = deck[j]; // Reverse copy.
            TrySwaps(deck2, f | k, d + 1, n);
        }
    }

    static int topswops(int n) {
        if(n <= 0 || n >= maxBest) throw new ArgumentOutOfRangeException(nameof(n), "n must be greater than 0 and less than maxBest.");
        best[n] = 0;
        int[] deck0 = new int[n + 1];
        for (int i = 1; i < n; i++)
            deck0[i] = -1;
        TrySwaps(deck0, 1, 0, n);
        return best[n];
    }

    public static void Main(string[] args) {
        best = new int[maxBest];
        for (int i = 1; i < 11; i++)
            Console.WriteLine(i + ": " + topswops(i));
    }
}
