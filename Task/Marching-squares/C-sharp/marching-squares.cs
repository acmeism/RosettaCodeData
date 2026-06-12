using System;
using System.Collections.Generic;
using System.Text;

public class PerimeterDetection
{
    // Direction constants
    private const int E = 0;
    private const int N = 1;
    private const int W = 2;
    private const int S = 3;

    // X generates coordinate pairs for a grid of given dimensions
    public static List<int[]> X(int a, int b)
    {
        List<int[]> c = new List<int[]>();
        for (int aa = 0; aa <= a; aa++)
        {
            for (int bb = 0; bb <= b; bb++)
            {
                c.Add(new int[] { aa, bb });
            }
        }
        return c;
    }

    // Any checks if any element in the array equals val
    public static bool Any(int[] arr, int val)
    {
        foreach (int v in arr)
        {
            if (v == val)
            {
                return true;
            }
        }
        return false;
    }

    // Result class to return multiple values from IdentifyPerimeter
    public class PerimeterResult
    {
        public int X { get; }
        public int Y { get; }
        public string Path { get; }

        public PerimeterResult(int x, int y, string path)
        {
            X = x;
            Y = y;
            Path = path;
        }
    }

    // IdentifyPerimeter identifies the perimeter of a shape in a 2D matrix
    public static PerimeterResult IdentifyPerimeter(int[,] data)
    {
        int rows = data.GetLength(0);
        int cols = data.GetLength(1);

        foreach (int[] coords in X(cols - 1, rows - 1))
        {
            int x = coords[0];
            int y = coords[1];

            if (y < rows && x < cols && data[y, x] != 0)
            {
                StringBuilder path = new StringBuilder();
                int cx = x, cy = y;
                int d = 0, p = 0;

                do
                {
                    int mask = 0;

                    int[,] vals = { { 0, 0, 1 }, { 1, 0, 2 }, { 0, 1, 4 }, { 1, 1, 8 } };
                    for (int i = 0; i < vals.GetLength(0); i++)
                    {
                        int dx = vals[i, 0];
                        int dy = vals[i, 1];
                        int b = vals[i, 2];
                        int mx = cx + dx;
                        int my = cy + dy;

                        if (mx > 0 && my > 0 && my - 1 < rows &&
                            mx - 1 < cols && data[my - 1, mx - 1] != 0)
                        {
                            mask += b;
                        }
                    }

                    if (Any(new int[] { 1, 5, 13 }, mask))
                    {
                        d = N;
                    }
                    if (Any(new int[] { 2, 3, 7 }, mask))
                    {
                        d = E;
                    }
                    if (Any(new int[] { 4, 12, 14 }, mask))
                    {
                        d = W;
                    }
                    if (Any(new int[] { 8, 10, 11 }, mask))
                    {
                        d = S;
                    }
                    if (mask == 6)
                    {
                        if (p == N)
                        {
                            d = W;
                        }
                        else
                        {
                            d = E;
                        }
                    }
                    if (mask == 9)
                    {
                        if (p == E)
                        {
                            d = N;
                        }
                        else
                        {
                            d = S;
                        }
                    }

                    char[] dirChars = { 'E', 'N', 'W', 'S' };
                    path.Append(dirChars[d]);
                    p = d;

                    int[] dxVals = { 1, 0, -1, 0 };
                    int[] dyVals = { 0, -1, 0, 1 };
                    cx += dxVals[d];
                    cy += dyVals[d];

                } while (!(cx == x && cy == y));

                return new PerimeterResult(x, -y, path.ToString());
            }
        }

        Console.WriteLine("That did not work out...");
        Environment.Exit(1);
        return null; // This line will never be reached due to Environment.Exit
    }

    public static void Main(string[] args)
    {
        int[,] M = {
            { 0, 0, 0, 0, 0 },
            { 0, 0, 0, 0, 0 },
            { 0, 0, 1, 1, 0 },
            { 0, 0, 1, 1, 0 },
            { 0, 0, 0, 1, 0 },
            { 0, 0, 0, 0, 0 }
        };

        PerimeterResult result = IdentifyPerimeter(M);
        Console.WriteLine($"X: {result.X}, Y: {result.Y}, Path: {result.Path}");
    }
}
