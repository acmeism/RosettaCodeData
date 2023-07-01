using System;
using System.Collections.Generic;
using System.Linq;

public static class ElementWiseOperations
{
    private static readonly Dictionary<string, Func<double, double, double>> operations =
        new Dictionary<string, Func<double, double, double>> {
            { "add", (a, b) => a + b },
            { "sub", (a, b) => a - b },
            { "mul", (a, b) => a * b },
            { "div", (a, b) => a / b },
            { "pow", (a, b) => Math.Pow(a, b) }
        };

    private static readonly Func<double, double, double> nothing = (a, b) => a;

    public static double[,] DoOperation(this double[,] m, string name, double[,] other) =>
        DoOperation(m, operations.TryGetValue(name, out var operation) ? operation : nothing, other);

    public static double[,] DoOperation(this double[,] m, Func<double, double, double> operation, double[,] other) {
        if (m == null || other == null) throw new ArgumentNullException();
        int rows = m.GetLength(0), columns = m.GetLength(1);
        if (rows != other.GetLength(0) || columns != other.GetLength(1)) {
            throw new ArgumentException("Matrices have different dimensions.");
        }

        double[,] result = new double[rows, columns];
        for (int r = 0; r < rows; r++) {
            for (int c = 0; c < columns; c++) {
                result[r, c] = operation(m[r, c], other[r, c]);
            }
        }
        return result;
    }

    public static double[,] DoOperation(this double[,] m, string name, double number) =>
        DoOperation(m, operations.TryGetValue(name, out var operation) ? operation : nothing, number);

    public static double[,] DoOperation(this double[,] m, Func<double, double, double> operation, double number) {
        if (m == null) throw new ArgumentNullException();
        int rows = m.GetLength(0), columns = m.GetLength(1);
        double[,] result = new double[rows, columns];
        for (int r = 0; r < rows; r++) {
            for (int c = 0; c < columns; c++) {
                result[r, c] = operation(m[r, c], number);
            }
        }
        return result;
    }

    public static void Print(this double[,] m) {
        if (m == null) throw new ArgumentNullException();
        int rows = m.GetLength(0), columns = m.GetLength(1);
        for (int r = 0; r < rows; r++) {
            Console.WriteLine("[ " + string.Join(", ", Enumerable.Range(0, columns).Select(c => m[r, c])) + " ]");
        }
    }

}

public class Program
{
    public static void Main() {
        double[,] matrix = {
            { 1, 2, 3, 4 },
            { 5, 6, 7, 8 },
            { 9, 10, 11, 12 }
        };

        double[,] tens = {
            { 10, 10, 10, 10 },
            { 20, 20, 20, 20 },
            { 30, 30, 30, 30 }
        };

        matrix.Print();
        WriteLine();

        (matrix = matrix.DoOperation("add", tens)).Print();
        WriteLine();

        matrix.DoOperation((a, b) => b - a, 100).Print();
    }
}
