using System.Linq;
using static System.Linq.Enumerable;
using System.Collections.Generic;
using System;
using System.Runtime.CompilerServices;

namespace SodukoFastMemoBFS {
    internal readonly record struct Square (int Row, int Col);
    internal record Constraints (IEnumerable<int> ConstrainedRange, Square Square);
    internal class Cache : Dictionary<Square, Constraints> { };
    internal record CacheGrid (int[][] Grid, Cache Cache);

    internal static class SudokuFastMemoBFS {
        internal static U Fwd<T, U>(this T data, Func<T, U> f) => f(data);

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        private static int RowCol(int rc) => rc <= 2 ? 0 : rc <= 5 ? 3 : 6;

        private static bool Solve(this CacheGrid cg, Constraints constraints, int finished) {
            var (row, col) = constraints.Square;
            foreach (var i in constraints.ConstrainedRange) {
                cg.Grid[row][col] = i;
                if (cg.Cache.Count == finished || cg.Solve(cg.Next(constraints.Square), finished))
                    return true;
            }
            cg.Grid[row][col] = 0;
            return false;
        }

        private static readonly int[] domain = Range(0, 9).ToArray();
        private static readonly int[] range = Range(1, 9).ToArray();

        private static bool Valid(this int[][] grid, int row, int col, int val) {
            for (var i = 0; i < 9; i++)
                if (grid[row][i] == val || grid[i][col] == val)
                    return false;
            for (var r = RowCol(row); r < RowCol(row) + 3; r++)
                for (var c = RowCol(col); c < RowCol(col) + 3; c++)
                    if (grid[r][c] == val)
                        return false;
            return true;
        }

        private static IEnumerable<int> Constraints(this int[][] grid, int row, int col) =>
            range.Where(val => grid.Valid(row, col, val));

        private static Constraints Next(this CacheGrid cg, Square square) =>
            cg.Cache.ContainsKey(square)
            ? cg.Cache[square]
            : cg.Cache[square]=cg.Grid.SortedCells();

        private static Constraints SortedCells(this int[][] grid) =>
            (from row in domain
            from col in domain
            where grid[row][col] == 0
            let cell = new Constraints(grid.Constraints(row, col), new Square(row, col))
            orderby cell.ConstrainedRange.Count() ascending
            select cell).First();

        private static CacheGrid Parse(string input) =>
            input
            .Select((c, i) => (index: i, val: int.Parse(c.ToString())))
            .GroupBy(id => id.index / 9)
            .Select(grp => grp.Select(id => id.val).ToArray())
            .ToArray()
            .Fwd(grid => new CacheGrid(grid, new Cache()));

        public static string AsString(this int[][] grid) =>
            string.Join('\n', grid.Select(row => string.Concat(row)));

        public static int[][] Run(string input) {
            var cg = Parse(input);
            var marked = cg.Grid.SelectMany(row => row.Where(c => c > 0)).Count();
            return cg.Solve(cg.Grid.SortedCells(), 80 - marked) ? cg.Grid : new int[][] { Array.Empty<int>() };
        }
    }
}
