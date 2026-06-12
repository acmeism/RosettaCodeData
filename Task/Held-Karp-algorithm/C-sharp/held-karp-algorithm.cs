using System;
using System.Collections.Generic;
using System.Linq;

public sealed class HeldKarpAlgorithm
{
    public class Result
    {
        public int Cost { get; }
        public List<int> Tour { get; }

        public Result(int cost, List<int> tour)
        {
            Cost = cost;
            Tour = tour;
        }
    }

    public static void Main(string[] args)
    {
        List<List<int>> distances = new List<List<int>>
        {
            new List<int> { 0,  2,  9, 10 },
            new List<int> { 1,  0,  6,  4 },
            new List<int> { 15, 7,  0,  8 },
            new List<int> { 6,  3, 12,  0 }
        };

        Result result = HeldKarp(distances);

        Console.WriteLine("Minimum tour cost: " + result.Cost);
        Console.WriteLine("Tour: " + string.Join(" -> ", result.Tour));
    }

    private static Result HeldKarp(List<List<int>> distances)
    {
        int n = distances.Count;
        int subsetCount = 1 << n;
        const int INFINITY = int.MaxValue / 4;

        List<List<int>> dp = new List<List<int>>(subsetCount);
        List<List<int>> parents = new List<List<int>>(subsetCount);

        for (int i = 0; i < subsetCount; i++)
        {
            dp.Add(Enumerable.Repeat(INFINITY, n).ToList());
            parents.Add(Enumerable.Repeat(-1, n).ToList());
        }

        dp[1][0] = 0;

        for (int mask = 1; mask < subsetCount; mask++)
        {
            if ((mask & 1) == 0)
                continue;

            for (int j = 1; j < n; j++)
            {
                if ((mask & (1 << j)) == 0)
                    continue;

                int previousMask = mask ^ (1 << j);
                for (int k = 0; k < n; k++)
                {
                    if ((previousMask & (1 << k)) == 0)
                        continue;

                    int cost = dp[previousMask][k] + distances[k][j];
                    if (cost < dp[mask][j])
                    {
                        dp[mask][j] = cost;
                        parents[mask][j] = k;
                    }
                }
            }
        }

        int fullMask = subsetCount - 1;
        int minCost = INFINITY;
        int lastCity = 0;
        for (int j = 1; j < n; j++)
        {
            int cost = dp[fullMask][j] + distances[j][0];
            if (cost < minCost)
            {
                minCost = cost;
                lastCity = j;
            }
        }

        List<int> tour = new List<int>();
        int currentMask = fullMask;
        int currentCity = lastCity;

        while (currentCity != 0)
        {
            tour.Add(currentCity);
            int prevCity = parents[currentMask][currentCity];
            currentMask ^= (1 << currentCity);
            currentCity = prevCity;
        }

        tour.Add(0);
        tour.Reverse();
        tour.Add(0);

        return new Result(minCost, tour);
    }
}
