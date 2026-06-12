using System;
using System.Collections.Generic;
using System.Linq;

public class WalshMatrix
{
    public static void Main(string[] args)
    {
        foreach (string type in new List<string> { "Natural", "Sequency" })
        {
            foreach (int order in new List<int> { 2, 4, 5 })
            {
                int size = 1 << order;
                Console.WriteLine($"Walsh matrix of order {order}, {type} order:");

                List<List<int>> walsh = GenerateWalshMatrix(size);

                if (type == "Sequency")
                {
                    walsh.Sort(RowComparator);
                }

                Display(walsh);
            }
        }
    }

    private static List<List<int>> GenerateWalshMatrix(int size)
    {
        List<List<int>> walsh = Enumerable.Range(0, size)
            .Select(i => new List<int>(new int[size]))
            .ToList();

        walsh[0][0] = 1;

        int k = 1;
        while (k < size)
        {
            for (int i = 0; i < k; i++)
            {
                for (int j = 0; j < k; j++)
                {
                    walsh[i + k][j] = walsh[i][j];
                    walsh[i][j + k] = walsh[i][j];
                    walsh[i + k][j + k] = -walsh[i][j];
                }
            }
            k += k;
        }
        return walsh;
    }

    private static int SignChangeCount(List<int> row)
    {
        int signChanges = 0;
        for (int i = 1; i < row.Count; i++)
        {
            if (row[i - 1] == -row[i])
            {
                signChanges++;
            }
        }
        return signChanges;
    }

    private static int RowComparator(List<int> one, List<int> two)
    {
        return SignChangeCount(one).CompareTo(SignChangeCount(two));
    }

    private static void Display(List<List<int>> matrix)
    {
        foreach (List<int> row in matrix)
        {
            foreach (int element in row)
            {
                Console.Write($"{element,3}");
            }
            Console.WriteLine();
        }
        Console.WriteLine();
    }
}

