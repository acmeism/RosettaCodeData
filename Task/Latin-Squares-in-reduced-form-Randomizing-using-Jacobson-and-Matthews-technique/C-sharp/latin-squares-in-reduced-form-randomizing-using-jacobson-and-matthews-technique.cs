using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;

public sealed class LatinSquaresInReducedForm
{
    private static readonly Random random = new Random();

    public static void Main(string[] args)
    {
        Console.WriteLine("PART 1: 10,000 latin Squares of order 4 in reduced form:\n");
        int[,] original4 = new int[,] { { 1, 2, 3, 4 }, { 2, 1, 4, 3 }, { 3, 4, 1, 2 }, { 4, 3, 2, 1 } };
        Dictionary<string, int> frequencies = new Dictionary<string, int>();
        int[,,] cube = CreateCube(original4, 4);

        for (int i = 1; i <= 10_000; i++)
        {
            ShuffleCube(cube);
            int[,] matrix = ToMatrix(cube);
            Reduce(matrix);
            OneBased(matrix);
            string key = MatrixToString(matrix);
            if (frequencies.ContainsKey(key))
                frequencies[key]++;
            else
                frequencies[key] = 1;
        }

        foreach (var entry in frequencies)
        {
            Console.Write(entry.Key);
            Console.WriteLine($" occurs {entry.Value} times");
        }

        Console.WriteLine("\nPART 2: 10_000 latin squares of order 5 in reduced form:");
        int[,] original5 = new int[,] {
            { 1, 2, 3, 4, 5 },
            { 2, 3, 4, 5, 1 },
            { 3, 4, 5, 1, 2 },
            { 4, 5, 1, 2, 3 },
            { 5, 1, 2, 3, 4 }
        };
        frequencies.Clear();
        cube = CreateCube(original5, 5);

        for (int i = 1; i <= 10_000; i++)
        {
            ShuffleCube(cube);
            int[,] matrix = ToMatrix(cube);
            Reduce(matrix);
            string key = MatrixToString(matrix);
            if (frequencies.ContainsKey(key))
                frequencies[key]++;
            else
                frequencies[key] = 1;
        }

        int count = 0;
        foreach (int frequency in frequencies.Values)
        {
            count++;
            Console.Write($"{(count > 1 ? ", " : "")}{(count % 8 == 1 ? "\n" : "")}{count,2}({frequency,3})");
        }

        Console.WriteLine("\n\nPART 3: 750 latin squares of order 42, showing the last one:\n");
        int[,] matrix42 = null;
        cube = CreateCube(null, 42);
        for (int i = 1; i <= 750; i++)
        {
            ShuffleCube(cube);
            if (i == 750)
            {
                matrix42 = ToMatrix(cube);
                OneBased(matrix42);
            }
        }
        PrintMatrix(matrix42);

        Console.WriteLine("\nPART 4: 1,000 latin squares of order 256:\n");
        Stopwatch stopwatch = Stopwatch.StartNew();
        cube = CreateCube(null, 256);
        for (int i = 1; i <= 1_000; i++)
        {
            ShuffleCube(cube);
        }
        stopwatch.Stop();
        Console.WriteLine($"Generated in {stopwatch.ElapsedMilliseconds} milliseconds");
    }

    private static void Reduce(int[,] matrix)
    {
        int size = matrix.GetLength(0);

        for (int j = 0; j < size - 1; j++)
        {
            if (matrix[0, j] != j)
            {
                for (int k = j + 1; k < size; k++)
                {
                    if (matrix[0, k] == j)
                    {
                        for (int i = 0; i < size; i++)
                        {
                            int temp = matrix[i, j];
                            matrix[i, j] = matrix[i, k];
                            matrix[i, k] = temp;
                        }
                        break;
                    }
                }
            }
        }

        for (int i = 1; i < size - 1; i++)
        {
            if (matrix[i, 0] != i)
            {
                for (int k = i + 1; k < size; k++)
                {
                    if (matrix[k, 0] == i)
                    {
                        for (int j = 0; j < size; j++)
                        {
                            int temp = matrix[i, j];
                            matrix[i, j] = matrix[k, j];
                            matrix[k, j] = temp;
                        }
                        break;
                    }
                }
            }
        }
    }

    private static int[,] ToMatrix(int[,,] cube)
    {
        int size = cube.GetLength(0);
        int[,] matrix = new int[size, size];
        for (int i = 0; i < size; i++)
        {
            for (int j = 0; j < size; j++)
            {
                for (int k = 0; k < size; k++)
                {
                    if (cube[i, j, k] != 0)
                    {
                        matrix[i, j] = k;
                        break;
                    }
                }
            }
        }
        return matrix;
    }

    private static void ShuffleCube(int[,,] cube)
    {
        int size = cube.GetLength(0);
        bool proper = true;

        int rx, ry, rz;
        do
        {
            rx = random.Next(0, size);
            ry = random.Next(0, size);
            rz = random.Next(0, size);
        } while (cube[rx, ry, rz] != 0);

        while (true)
        {
            int ox = 0, oy = 0, oz = 0;

            while (cube[ox, ry, rz] != 1)
            {
                ox++;
            }
            while (cube[rx, oy, rz] != 1)
            {
                oy++;
            }
            while (cube[rx, ry, oz] != 1)
            {
                oz++;
            }

            if (!proper)
            {
                if (random.Next(2) == 0)
                {
                    ox++;
                    while (cube[ox, ry, rz] != 1)
                    {
                        ox++;
                    }
                }
                if (random.Next(2) == 0)
                {
                    oy++;
                    while (cube[rx, oy, rz] != 1)
                    {
                        oy++;
                    }
                }
                if (random.Next(2) == 0)
                {
                    oz++;
                    while (cube[rx, ry, oz] != 1)
                    {
                        oz++;
                    }
                }
            }

            cube[rx, ry, rz]++;
            cube[rx, oy, oz]++;
            cube[ox, ry, oz]++;
            cube[ox, oy, rz]++;

            cube[rx, ry, oz]--;
            cube[rx, oy, rz]--;
            cube[ox, ry, rz]--;
            cube[ox, oy, oz]--;

            if (cube[ox, oy, oz] < 0)
            {
                rx = ox; ry = oy; rz = oz;
                proper = false;
            }
            else
            {
                break;
            }
        }
    }

    private static int[,,] CreateCube(int[,] matrix, int size)
    {
        int[,,] cube = new int[size, size, size];
        for (int i = 0; i < size; i++)
        {
            for (int j = 0; j < size; j++)
            {
                int k = (matrix == null) ? (i + j) % size : matrix[i, j] - 1;
                cube[i, j, k] = 1;
            }
        }
        return cube;
    }

    private static void OneBased(int[,] matrix)
    {
        int rows = matrix.GetLength(0);
        int cols = matrix.GetLength(1);
        for (int i = 0; i < rows; i++)
        {
            for (int j = 0; j < cols; j++)
            {
                matrix[i, j]++;
            }
        }
    }

    private static string MatrixToString(int[,] matrix)
    {
        int rows = matrix.GetLength(0);
        int cols = matrix.GetLength(1);
        var result = new System.Text.StringBuilder();
        result.Append("[");
        for (int i = 0; i < rows; i++)
        {
            result.Append("[");
            for (int j = 0; j < cols; j++)
            {
                result.Append(matrix[i, j]);
                if (j < cols - 1) result.Append(", ");
            }
            result.Append("]");
            if (i < rows - 1) result.Append(", ");
        }
        result.Append("]");
        return result.ToString();
    }

    private static void PrintMatrix(int[,] matrix)
    {
        int rows = matrix.GetLength(0);
        int cols = matrix.GetLength(1);
        for (int i = 0; i < rows; i++)
        {
            Console.Write("[");
            for (int j = 0; j < cols; j++)
            {
                Console.Write(matrix[i, j]);
                if (j < cols - 1) Console.Write(", ");
            }
            Console.WriteLine("]");
        }
    }
}
