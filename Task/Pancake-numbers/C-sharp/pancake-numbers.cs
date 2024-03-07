using System;

public class Pancake
{
    private static int pancake(int n)
    {
        int gap = 2;
        int sum = 2;
        int adj = -1;
        while (sum < n)
        {
            adj++;
            gap = 2 * gap - 1;
            sum += gap;
        }
        return n + adj;
    }

    public static void Main(string[] args)
    {
        for (int i = 0; i < 4; i++)
        {
            for (int j = 1; j < 6; j++)
            {
                int n = 5 * i + j;
                Console.Write($"p({n,2}) = {pancake(n),2}  ");
            }
            Console.WriteLine();
        }
    }
}
