using System;
using System.Collections;
using System.Collections.Generic;
using static System.Linq.Enumerable;

public static class MatrixExponentation
{
    public static double[,] Identity(int size) {
        double[,] matrix = new double[size, size];
        for (int i = 0; i < size; i++) matrix[i, i] = 1;
        return matrix;
    }

    public static double[,] Multiply(this double[,] left, double[,] right) {
        if (left.ColumnCount() != right.RowCount()) throw new ArgumentException();
        double[,] m = new double[left.RowCount(), right.ColumnCount()];
        foreach (var (row, column) in from r in Range(0, m.RowCount()) from c in Range(0, m.ColumnCount()) select (r, c)) {
            m[row, column] = Range(0, m.RowCount()).Sum(i => left[row, i] * right[i, column]);
        }
        return m;
    }

    public static double[,] Pow(this double[,] matrix, int exp) {
        if (matrix.RowCount() != matrix.ColumnCount()) throw new ArgumentException("Matrix must be square.");
        double[,] accumulator = Identity(matrix.RowCount());
        for (int i = 0; i < exp; i++) {
            accumulator = accumulator.Multiply(matrix);
        }
        return accumulator;
    }

    private static int RowCount(this double[,] matrix) => matrix.GetLength(0);
    private static int ColumnCount(this double[,] matrix) => matrix.GetLength(1);

    private static void Print(this double[,] m) {
        foreach (var row in Rows()) {
            Console.WriteLine("[ " + string.Join("   ", row) + " ]");
        }
        Console.WriteLine();

        IEnumerable<IEnumerable<double>> Rows() =>
            Range(0, m.RowCount()).Select(row => Range(0, m.ColumnCount()).Select(column => m[row, column]));
    }

    public static void Main() {
        var matrix = new double[,] {
            { 3, 2 },
            { 2, 1 }
        };

        matrix.Pow(0).Print();
        matrix.Pow(1).Print();
        matrix.Pow(2).Print();
        matrix.Pow(3).Print();
        matrix.Pow(4).Print();
        matrix.Pow(50).Print();
    }

}
