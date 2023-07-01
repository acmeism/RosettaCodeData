using System;
using System.Collections;
using System.Collections.Generic;
using static System.Linq.Enumerable;

public static class KroneckerProduct
{
    public static void Main() {
        int[,] left = { {1, 2}, {3, 4} };
        int[,] right = { {0, 5}, {6, 7} };
        Print(Multiply(left, right));

        left = new [,] { {0, 1, 0}, {1, 1, 1}, {0, 1, 0} };
        right = new [,] { {1, 1, 1, 1}, {1, 0, 0, 1}, {1, 1, 1, 1} };
        Print(Multiply(left, right));
    }

    static int[,] Multiply(int[,] left, int[,] right) {
        (int lRows, int lColumns) = (left.GetLength(0), left.GetLength(1));
        (int rRows, int rColumns) = (right.GetLength(0), right.GetLength(1));
        int[,] result = new int[lRows * rRows, lColumns * rColumns];

        foreach (var (r, c) in from r in Range(0, lRows) from c in Range(0, lColumns) select (r, c)) {
            Copy(r * rRows, c * rColumns, left[r, c]);
        }
        return result;

        void Copy(int startRow, int startColumn, int multiplier) {
            foreach (var (r, c) in from r in Range(0, rRows) from c in Range(0, rColumns) select (r, c)) {
                result[startRow + r, startColumn + c] = right[r, c] * multiplier;
            }
        }
    }

    static void Print(int[,] matrix) {
        (int rows, int columns) = (matrix.GetLength(0), matrix.GetLength(1));
        int width = matrix.Cast<int>().Select(LengthOf).Max();
        for (int row = 0; row < rows; row++) {
            Console.WriteLine("| " + string.Join(" ", Range(0, columns).Select(column => (matrix[row, column] + "").PadLeft(width, ' '))) + " |");
        }
        Console.WriteLine();
    }

    private static int LengthOf(int i) {
        if (i < 0) return LengthOf(-i) + 1;
        int length = 0;
        while (i > 0) {
            length++;
            i /= 10;
        }
        return length;
    }

}
