using System;
using System.Collections.Generic;

public class PfaffianAndHfaffian
{
    public static void Main(string[] args)
    {
        List<int[,]> matrices = new List<int[,]>
        {
            new int[,] { {  0,  1 }, { -1,  0 } }, // Tiny 2 x 2 matrix

            new int[,] { {  0,  1, -1,  2 }, // Small 4 x 4 matrix
                          { -1,  0,  3, -4 },
                          {  1, -3,  0,  5 },
                          { -2,  4, -5,  0 } },

            new int[,] { { 1,  2,  3,  4,  5,  6 }, // Symmetric 6 x 6 matrix
                          { 2,  7,  8,  9, 10, 11 },
                          { 3,  8, 12, 13, 14, 15 },
                          { 4,  9, 13, 16, 17, 18 },
                          { 5, 10, 14, 17, 19, 20 },
                          { 6, 11, 15, 18, 20, 21 } },

            new int[,] { {  0,  1,  2,  3,  4,  5,  6,  7,  8,  9 }, // Larger 10 x 10 matrix
                          { -1,  0,  8,  7,  6,  5,  4,  3,  2,  1 },
                          { -2, -8,  0,  1,  2,  3,  4,  5,  6,  7 },
                          { -3, -7, -1,  0,  6,  5,  4,  3,  2,  1 },
                          { -4, -6, -2, -6,  0,  1,  2,  3,  4,  5 },
                          { -5, -5, -3, -5, -1,  0,  4,  3,  2,  1 },
                          { -6, -4, -4, -4, -2, -4,  0,  1,  2,  3 },
                          { -7, -3, -5, -3, -3, -3, -1,  0,  2,  1 },
                          { -8, -2, -6, -2, -4, -2, -2, -2,  0,  1 },
                          { -9, -1, -7, -1, -5, -1, -3, -1, -1,  0 } }
        };

        foreach (var matrix in matrices)
        {
            PrintMatrix(matrix);
            foreach (Faffian faffian in Enum.GetValues(typeof(Faffian)))
            {
                var result = ComputeFaffian(matrix, faffian);
                if (result.HasValue)
                {
                    Console.WriteLine($"{faffian}: {result.Value}");
                }
            }
            Console.WriteLine();
        }
    }

    private static long? ComputeFaffian(int[,] matrix, Faffian faffian)
    {
        int size = matrix.GetLength(0);
        if (size % 2 != 0)
        {
            Console.WriteLine($"Matrix size must be even for {faffian}");
            return null;
        }

        if (!IsAntisymmetric(matrix))
        {
            Console.WriteLine($"The {faffian} does not support non-antisymmetric matrices");
            return null;
        }

        int n = size / 2;
        int sum = 0;
        List<SignedPerm> signedPerms = SignedPermutations(2 * n - 1);
        foreach (var signedPerm in signedPerms)
        {
            List<int> sigma = signedPerm.Permutation;
            int sign = (faffian == Faffian.Pfaffian) ? signedPerm.Sign : 1;
            int product = 1;
            for (int i = 0; i < n; i++)
            {
                product *= matrix[sigma[2 * i], sigma[2 * i + 1]];
            }
            sum += sign * product;
        }

        double normalization = 1.0 / Factorial(n) / Math.Pow(2, n);
        return (long)Math.Round(sum * normalization);
    }

    private static List<SignedPerm> SignedPermutations(int n)
    {
        List<int> perms = new List<int>();
        for (int i = 0; i <= n; i++)
        {
            perms.Add(i);
        }
        List<SignedPerm> signedPerms = new List<SignedPerm> { new SignedPerm(new List<int>(perms), 1) };
        int sign = 1;
        for (int k = 1; k < Factorial(n + 1); k++)
        {
            int i = n - 1;
            int j = n;
            while (perms[i] > perms[i + 1])
            {
                i--;
            }
            while (perms[j] < perms[i])
            {
                j--;
            }
            Swap(perms, i, j);
            sign = -sign;
            i++;
            j = n;
            while (i < j)
            {
                Swap(perms, i, j);
                sign = -sign;
                i++;
                j--;
            }
            signedPerms.Add(new SignedPerm(new List<int>(perms), sign));
        }
        return signedPerms;
    }

    private static bool IsAntisymmetric(int[,] matrix)
    {
        int size = matrix.GetLength(0);
        for (int i = 0; i < size; i++)
        {
            if (matrix[i, i] != 0)
            {
                return false;
            }
            for (int j = i + 1; j < size; j++)
            {
                if (matrix[i, j] != -matrix[j, i])
                {
                    return false;
                }
            }
        }
        return true;
    }

    private static int Factorial(int n)
    {
        int factorial = 1;
        for (int i = 2; i <= n; i++)
        {
            factorial *= i;
        }
        return factorial;
    }

    private static void Swap(List<int> list, int i, int j)
    {
        int temp = list[i];
        list[i] = list[j];
        list[j] = temp;
    }

    private static void PrintMatrix(int[,] matrix)
    {
        for (int i = 0; i < matrix.GetLength(0); i++)
        {
            Console.Write("|");
            for (int j = 0; j < matrix.GetLength(1); j++)
            {
                Console.Write($"{matrix[i, j],2}, ");
            }
            Console.WriteLine();
        }
    }

    private class SignedPerm
    {
        public List<int> Permutation { get; }
        public int Sign { get; }

        public SignedPerm(List<int> permutation, int sign)
        {
            Permutation = permutation;
            Sign = sign;
        }
    }

    private enum Faffian { Pfaffian, Hfaffian }
}

