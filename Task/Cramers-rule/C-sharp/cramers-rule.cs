using System;
using System.Collections.Generic;
using static System.Linq.Enumerable;

public static class CramersRule
{
    public static void Main() {
        var equations = new [] {
            new [] { 2, -1,  5,  1,  -3 },
            new [] { 3,  2,  2, -6, -32 },
            new [] { 1,  3,  3, -1, -47 },
            new [] { 5, -2, -3,  3,  49 }
        };
        var solution = SolveCramer(equations);
        Console.WriteLine(solution.DelimitWith(", "));
    }

    public static int[] SolveCramer(int[][] equations) {
        int size = equations.Length;
        if (equations.Any(eq => eq.Length != size + 1)) throw new ArgumentException($"Each equation must have {size+1} terms.");
        int[,] matrix = new int[size, size];
        int[] column = new int[size];
        for (int r = 0; r < size; r++) {
            column[r] = equations[r][size];
            for (int c = 0; c < size; c++) {
                matrix[r, c] = equations[r][c];
            }
        }
        return Solve(new SubMatrix(matrix, column));
    }

    private static int[] Solve(SubMatrix matrix) {
        int det = matrix.Det();
        if (det == 0) throw new ArgumentException("The determinant is zero.");

        int[] answer = new int[matrix.Size];
        for (int i = 0; i < matrix.Size; i++) {
            matrix.ColumnIndex = i;
            answer[i] = matrix.Det() / det;
        }
        return answer;
    }

    //Extension method from library.
    static string DelimitWith<T>(this IEnumerable<T> source, string separator = " ") =>
        string.Join(separator ?? " ", source ?? Empty<T>());

    private class SubMatrix
    {
        private int[,] source;
        private SubMatrix prev;
        private int[] replaceColumn;

        public SubMatrix(int[,] source, int[] replaceColumn) {
            this.source = source;
            this.replaceColumn = replaceColumn;
            this.prev = null;
            this.ColumnIndex = -1;
            Size = replaceColumn.Length;
        }

        private SubMatrix(SubMatrix prev, int deletedColumnIndex = -1) {
            this.source = null;
            this.prev = prev;
            this.ColumnIndex = deletedColumnIndex;
            Size = prev.Size - 1;
        }

        public int ColumnIndex { get; set; }
        public int Size { get; }

        public int this[int row, int column] {
            get {
                if (source != null) return column == ColumnIndex ? replaceColumn[row] : source[row, column];
                return prev[row + 1, column < ColumnIndex ? column : column + 1];
            }
        }

        public int Det() {
            if (Size == 1) return this[0, 0];
            if (Size == 2) return this[0, 0] * this[1, 1] - this[0, 1] * this[1, 0];
            SubMatrix m = new SubMatrix(this);
            int det = 0;
            int sign = 1;
            for (int c = 0; c < Size; c++) {
                m.ColumnIndex = c;
                int d = m.Det();
                det += this[0, c] * d * sign;
                sign = -sign;
            }
            return det;
        }

        public void Print() {
            for (int r = 0; r < Size; r++) {
                Console.WriteLine(Range(0, Size).Select(c => this[r, c]).DelimitWith(", "));
            }
            Console.WriteLine();
        }
    }

}
