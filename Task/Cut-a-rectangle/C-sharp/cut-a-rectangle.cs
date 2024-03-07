using System;
using System.Collections.Generic;

public class CutRectangle
{
    private static int[][] dirs = new int[][] { new int[] { 0, -1 }, new int[] { -1, 0 }, new int[] { 0, 1 }, new int[] { 1, 0 } };

    public static void Main(string[] args)
    {
        CutRectangleMethod(2, 2);
        CutRectangleMethod(4, 3);
    }

    static void CutRectangleMethod(int w, int h)
    {
        if (w % 2 == 1 && h % 2 == 1)
            return;

        int[,] grid = new int[h, w];
        Stack<int> stack = new Stack<int>();

        int half = (w * h) / 2;
        long bits = (long)Math.Pow(2, half) - 1;

        for (; bits > 0; bits -= 2)
        {
            for (int i = 0; i < half; i++)
            {
                int r = i / w;
                int c = i % w;
                grid[r, c] = (bits & (1L << i)) != 0 ? 1 : 0;
                grid[h - r - 1, w - c - 1] = 1 - grid[r, c];
            }

            stack.Push(0);
            grid[0, 0] = 2;
            int count = 1;
            while (stack.Count > 0)
            {
                int pos = stack.Pop();
                int r = pos / w;
                int c = pos % w;

                foreach (var dir in dirs)
                {
                    int nextR = r + dir[0];
                    int nextC = c + dir[1];

                    if (nextR >= 0 && nextR < h && nextC >= 0 && nextC < w)
                    {
                        if (grid[nextR, nextC] == 1)
                        {
                            stack.Push(nextR * w + nextC);
                            grid[nextR, nextC] = 2;
                            count++;
                        }
                    }
                }
            }
            if (count == half)
            {
                PrintResult(grid, h, w);
            }
        }
    }

    static void PrintResult(int[,] arr, int height, int width)
    {
        for (int i = 0; i < height; i++)
        {
            for (int j = 0; j < width; j++)
            {
                Console.Write(arr[i, j] + (j == width - 1 ? "" : ", "));
            }
            Console.WriteLine();
        }
        Console.WriteLine();
    }
}
