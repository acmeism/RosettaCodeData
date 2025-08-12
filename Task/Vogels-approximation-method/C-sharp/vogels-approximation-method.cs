using System;
using System.Linq;
using System.Threading.Tasks;

public class VogelsApproximationMethod
{
    private static readonly int[] demand = {30, 20, 70, 30, 60};
    private static readonly int[] supply = {50, 60, 50, 50};
    private static readonly int[,] costs = {{16, 16, 13, 22, 17}, {14, 14, 13, 19, 15},
        {19, 19, 20, 23, 50}, {50, 12, 50, 15, 11}};

    private static readonly int nRows = supply.Length;
    private static readonly int nCols = demand.Length;

    private static bool[] rowDone = new bool[nRows];
    private static bool[] colDone = new bool[nCols];
    private static int[,] result = new int[nRows, nCols];

    public static async Task Main(string[] args)
    {
        int supplyLeft = supply.Sum();
        int totalCost = 0;

        while (supplyLeft > 0)
        {
            int[] cell = await NextCell();
            int r = cell[0];
            int c = cell[1];

            int quantity = Math.Min(demand[c], supply[r]);
            demand[c] -= quantity;
            if (demand[c] == 0)
                colDone[c] = true;

            supply[r] -= quantity;
            if (supply[r] == 0)
                rowDone[r] = true;

            result[r, c] = quantity;
            supplyLeft -= quantity;

            totalCost += quantity * costs[r, c];
        }

        // Print results
        for (int i = 0; i < nRows; i++)
        {
            Console.Write("[");
            for (int j = 0; j < nCols; j++)
            {
                Console.Write(result[i, j]);
                if (j < nCols - 1) Console.Write(", ");
            }
            Console.WriteLine("]");
        }
        Console.WriteLine($"Total cost: {totalCost}");
    }

    private static async Task<int[]> NextCell()
    {
        Task<int[]> task1 = Task.Run(() => MaxPenalty(nRows, nCols, true));
        Task<int[]> task2 = Task.Run(() => MaxPenalty(nCols, nRows, false));

        int[] res1 = await task1;
        int[] res2 = await task2;

        if (res1[3] == res2[3])
            return res1[2] < res2[2] ? res1 : res2;

        return (res1[3] > res2[3]) ? res2 : res1;
    }

    private static int[] Diff(int j, int len, bool isRow)
    {
        int min1 = int.MaxValue, min2 = int.MaxValue;
        int minP = -1;

        for (int i = 0; i < len; i++)
        {
            if (isRow ? colDone[i] : rowDone[i])
                continue;

            int c = isRow ? costs[j, i] : costs[i, j];
            if (c < min1)
            {
                min2 = min1;
                min1 = c;
                minP = i;
            }
            else if (c < min2)
                min2 = c;
        }
        return new int[] {min2 - min1, min1, minP};
    }

    private static int[] MaxPenalty(int len1, int len2, bool isRow)
    {
        int md = int.MinValue;
        int pc = -1, pm = -1, mc = -1;

        for (int i = 0; i < len1; i++)
        {
            if (isRow ? rowDone[i] : colDone[i])
                continue;

            int[] res = Diff(i, len2, isRow);
            if (res[0] > md)
            {
                md = res[0];  // max diff
                pm = i;       // pos of max diff
                mc = res[1];  // min cost
                pc = res[2];  // pos of min cost
            }
        }
        return isRow ? new int[] {pm, pc, mc, md} : new int[] {pc, pm, mc, md};
    }
}
