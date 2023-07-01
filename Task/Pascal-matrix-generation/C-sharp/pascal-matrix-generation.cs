using System;

public static class PascalMatrixGeneration
{
    public static void Main() {
        Print(GenerateUpper(5));
        Console.WriteLine();
        Print(GenerateLower(5));
        Console.WriteLine();
        Print(GenerateSymmetric(5));
    }

    static int[,] GenerateUpper(int size) {
        int[,] m = new int[size, size];
        for (int c = 0; c < size; c++) m[0, c] = 1;
        for (int r = 1; r < size; r++) {
            for (int c = r; c < size; c++) {
                m[r, c] = m[r-1, c-1] + m[r, c-1];
            }
        }
        return m;
    }

    static int[,] GenerateLower(int size) {
        int[,] m = new int[size, size];
        for (int r = 0; r < size; r++) m[r, 0] = 1;
        for (int c = 1; c < size; c++) {
            for (int r = c; r < size; r++) {
                m[r, c] = m[r-1, c-1] + m[r-1, c];
            }
        }
        return m;
    }

    static int[,] GenerateSymmetric(int size) {
        int[,] m = new int[size, size];
        for (int i = 0; i < size; i++) m[0, i] = m[i, 0] = 1;
        for (int r = 1; r < size; r++) {
            for (int c = 1; c < size; c++) {
                m[r, c] = m[r-1, c] + m[r, c-1];
            }
        }
        return m;
    }

    static void Print(int[,] matrix) {
        string[,] m = ToString(matrix);
        int width = m.Cast<string>().Select(s => s.Length).Max();
        int rows = matrix.GetLength(0), columns = matrix.GetLength(1);
        for (int row = 0; row < rows; row++) {
            Console.WriteLine("|" + string.Join(" ", Range(0, columns).Select(column => m[row, column].PadLeft(width, ' '))) + "|");
        }
    }

    static string[,] ToString(int[,] matrix) {
        int rows = matrix.GetLength(0), columns = matrix.GetLength(1);
        string[,] m = new string[rows, columns];
        for (int r = 0; r < rows; r++) {
            for (int c = 0; c < columns; c++) {
                m[r, c] = matrix[r, c].ToString();
            }
        }
        return m;
    }

}
