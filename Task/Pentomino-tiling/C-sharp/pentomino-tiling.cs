using System;
using System.Linq;

namespace PentominoTiling
{
    class Program
    {
        static readonly char[] symbols = "FILNPTUVWXYZ-".ToCharArray();

        static readonly int nRows = 8;
        static readonly int nCols = 8;
        static readonly int target = 12;
        static readonly int blank = 12;

        static int[][] grid = new int[nRows][];
        static bool[] placed = new bool[target];

        static void Main(string[] args)
        {
            var rand = new Random();

            for (int r = 0; r < nRows; r++)
                grid[r] = Enumerable.Repeat(-1, nCols).ToArray();

            for (int i = 0; i < 4; i++)
            {
                int randRow, randCol;
                do
                {
                    randRow = rand.Next(nRows);
                    randCol = rand.Next(nCols);
                }
                while (grid[randRow][randCol] == blank);

                grid[randRow][randCol] = blank;
            }

            if (Solve(0, 0))
            {
                PrintResult();
            }
            else
            {
                Console.WriteLine("no solution");
            }

            Console.ReadKey();
        }

        private static void PrintResult()
        {
            foreach (int[] r in grid)
            {
                foreach (int i in r)
                    Console.Write("{0} ", symbols[i]);
                Console.WriteLine();
            }
        }

        private static bool Solve(int pos, int numPlaced)
        {
            if (numPlaced == target)
                return true;

            int row = pos / nCols;
            int col = pos % nCols;

            if (grid[row][col] != -1)
                return Solve(pos + 1, numPlaced);

            for (int i = 0; i < shapes.Length; i++)
            {
                if (!placed[i])
                {
                    foreach (int[] orientation in shapes[i])
                    {
                        if (!TryPlaceOrientation(orientation, row, col, i))
                            continue;

                        placed[i] = true;

                        if (Solve(pos + 1, numPlaced + 1))
                            return true;

                        RemoveOrientation(orientation, row, col);
                        placed[i] = false;
                    }
                }
            }
            return false;
        }

        private static void RemoveOrientation(int[] orientation, int row, int col)
        {
            grid[row][col] = -1;
            for (int i = 0; i < orientation.Length; i += 2)
                grid[row + orientation[i]][col + orientation[i + 1]] = -1;
        }

        private static bool TryPlaceOrientation(int[] orientation, int row, int col, int shapeIndex)
        {
            for (int i = 0; i < orientation.Length; i += 2)
            {
                int x = col + orientation[i + 1];
                int y = row + orientation[i];
                if (x < 0 || x >= nCols || y < 0 || y >= nRows || grid[y][x] != -1)
                    return false;
            }

            grid[row][col] = shapeIndex;
            for (int i = 0; i < orientation.Length; i += 2)
                grid[row + orientation[i]][col + orientation[i + 1]] = shapeIndex;

            return true;
        }

        // four (x, y) pairs are listed, (0,0) not included
        static readonly int[][] F = {
            new int[] {1, -1, 1, 0, 1, 1, 2, 1}, new int[] {0, 1, 1, -1, 1, 0, 2, 0},
            new int[] {1, 0, 1, 1, 1, 2, 2, 1}, new int[] {1, 0, 1, 1, 2, -1, 2, 0},
            new int[] {1, -2, 1, -1, 1, 0, 2, -1}, new int[] {0, 1, 1, 1, 1, 2, 2, 1},
            new int[] {1, -1, 1, 0, 1, 1, 2, -1}, new int[] {1, -1, 1, 0, 2, 0, 2, 1}};

        static readonly int[][] I = {
            new int[] { 0, 1, 0, 2, 0, 3, 0, 4 }, new int[] { 1, 0, 2, 0, 3, 0, 4, 0 } };

        static readonly int[][] L = {
            new int[] {1, 0, 1, 1, 1, 2, 1, 3}, new int[] {1, 0, 2, 0, 3, -1, 3, 0},
            new int[] {0, 1, 0, 2, 0, 3, 1, 3}, new int[] {0, 1, 1, 0, 2, 0, 3, 0},
            new int[] {0, 1, 1, 1, 2, 1, 3, 1}, new int[] {0, 1, 0, 2, 0, 3, 1, 0},
            new int[] {1, 0, 2, 0, 3, 0, 3, 1}, new int[] {1, -3, 1, -2, 1, -1, 1, 0}};

        static readonly int[][] N = {
            new int[] {0, 1, 1, -2, 1, -1, 1, 0}, new int[] {1, 0, 1, 1, 2, 1, 3, 1},
            new int[]  {0, 1, 0, 2, 1, -1, 1, 0}, new int[] {1, 0, 2, 0, 2, 1, 3, 1},
            new int[] {0, 1, 1, 1, 1, 2, 1, 3}, new int[] {1, 0, 2, -1, 2, 0, 3, -1},
            new int[] {0, 1, 0, 2, 1, 2, 1, 3}, new int[] {1, -1, 1, 0, 2, -1, 3, -1}};

        static readonly int[][] P = {
            new int[] {0, 1, 1, 0, 1, 1, 2, 1}, new int[] {0, 1, 0, 2, 1, 0, 1, 1},
            new int[] {1, 0, 1, 1, 2, 0, 2, 1}, new int[] {0, 1, 1, -1, 1, 0, 1, 1},
            new int[] {0, 1, 1, 0, 1, 1, 1, 2}, new int[] {1, -1, 1, 0, 2, -1, 2, 0},
            new int[] {0, 1, 0, 2, 1, 1, 1, 2}, new int[] {0, 1, 1, 0, 1, 1, 2, 0}};

        static readonly int[][] T = {
            new int[] {0, 1, 0, 2, 1, 1, 2, 1}, new int[] {1, -2, 1, -1, 1, 0, 2, 0},
            new int[] {1, 0, 2, -1, 2, 0, 2, 1}, new int[] {1, 0, 1, 1, 1, 2, 2, 0}};

        static readonly int[][] U = {
            new int[] {0, 1, 0, 2, 1, 0, 1, 2}, new int[] {0, 1, 1, 1, 2, 0, 2, 1},
            new int[]  {0, 2, 1, 0, 1, 1, 1, 2}, new int[] {0, 1, 1, 0, 2, 0, 2, 1}};

        static readonly int[][] V = {
            new int[] {1, 0, 2, 0, 2, 1, 2, 2}, new int[] {0, 1, 0, 2, 1, 0, 2, 0},
            new int[] {1, 0, 2, -2, 2, -1, 2, 0}, new int[] {0, 1, 0, 2, 1, 2, 2, 2}};

        static readonly int[][] W = {
            new int[] {1, 0, 1, 1, 2, 1, 2, 2}, new int[] {1, -1, 1, 0, 2, -2, 2, -1},
            new int[] {0, 1, 1, 1, 1, 2, 2, 2}, new int[] {0, 1, 1, -1, 1, 0, 2, -1}};

        static readonly int[][] X = { new int[] { 1, -1, 1, 0, 1, 1, 2, 0 } };

        static readonly int[][] Y = {
            new int[] {1, -2, 1, -1, 1, 0, 1, 1}, new int[] {1, -1, 1, 0, 2, 0, 3, 0},
            new int[] {0, 1, 0, 2, 0, 3, 1, 1}, new int[] {1, 0, 2, 0, 2, 1, 3, 0},
            new int[] {0, 1, 0, 2, 0, 3, 1, 2}, new int[] {1, 0, 1, 1, 2, 0, 3, 0},
            new int[] {1, -1, 1, 0, 1, 1, 1, 2}, new int[] {1, 0, 2, -1, 2, 0, 3, 0}};

        static readonly int[][] Z = {
            new int[] {0, 1, 1, 0, 2, -1, 2, 0}, new int[] {1, 0, 1, 1, 1, 2, 2, 2},
            new int[] {0, 1, 1, 1, 2, 1, 2, 2}, new int[] {1, -2, 1, -1, 1, 0, 2, -2}};

        static readonly int[][][] shapes = { F, I, L, N, P, T, U, V, W, X, Y, Z };
    }
}
