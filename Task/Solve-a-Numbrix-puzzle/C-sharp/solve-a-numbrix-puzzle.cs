using System.Collections;
using System.Collections.Generic;
using static System.Console;
using static System.Math;
using static System.Linq.Enumerable;

public class Solver
{
    private static readonly (int dx, int dy)[]
        //other puzzle types elided
        numbrixMoves = {(1,0),(0,1),(-1,0),(0,-1)};

    private (int dx, int dy)[] moves;

    public static void Main()
    {
        var numbrixSolver = new Solver(numbrixMoves);
        Print(numbrixSolver.Solve(false, new [,] {
            {  0,  0,  0,  0,  0,  0,  0,  0,  0 },
            {  0,  0, 46, 45,  0, 55, 74,  0,  0 },
            {  0, 38,  0,  0, 43,  0,  0, 78,  0 },
            {  0, 35,  0,  0,  0,  0,  0, 71,  0 },
            {  0,  0, 33,  0,  0,  0, 59,  0,  0 },
            {  0, 17,  0,  0,  0,  0,  0, 67,  0 },
            {  0, 18,  0,  0, 11,  0,  0, 64,  0 },
            {  0,  0, 24, 21,  0,  1,  2,  0,  0 },
            {  0,  0,  0,  0,  0,  0,  0,  0,  0 },
        }));

        Print(numbrixSolver.Solve(false, new [,] {
            {  0,  0,  0,  0,  0,  0,  0,  0,  0 },
            {  0, 11, 12, 15, 18, 21, 62, 61,  0 },
            {  0,  6,  0,  0,  0,  0,  0, 60,  0 },
            {  0, 33,  0,  0,  0,  0,  0, 57,  0 },
            {  0, 32,  0,  0,  0,  0,  0, 56,  0 },
            {  0, 37,  0,  1,  0,  0,  0, 73,  0 },
            {  0, 38,  0,  0,  0,  0,  0, 72,  0 },
            {  0, 43, 44, 47, 48, 51, 76, 77,  0 },
            {  0,  0,  0,  0,  0,  0,  0,  0,  0 },
        }));
    }

    public Solver(params (int dx, int dy)[] moves) => this.moves = moves;

    public int[,] Solve(bool circular, params string[] puzzle)
    {
        var (board, given, count) = Parse(puzzle);
        return Solve(board, given, count, circular);
    }

    public int[,] Solve(bool circular, int[,] puzzle)
    {
        var (board, given, count) = Parse(puzzle);
        return Solve(board, given, count, circular);
    }

    private int[,] Solve(int[,] board, BitArray given, int count, bool circular)
    {
        var (height, width) = (board.GetLength(0), board.GetLength(1));
        bool solved = false;
        for (int x = 0; x < height && !solved; x++) {
            solved = Range(0, width).Any(y => Solve(board, given, circular, (height, width), (x, y), count, (x, y), 1));
            if (solved) return board;
        }
        return null;
    }

    private bool Solve(int[,] board, BitArray given, bool circular,
        (int h, int w) size, (int x, int y) start, int last, (int x, int y) current, int n)
    {
        var (x, y) = current;
        if (x < 0 || x >= size.h || y < 0 || y >= size.w) return false;
        if (board[x, y] < 0) return false;
        if (given[n - 1]) {
            if (board[x, y] != n) return false;
        } else if (board[x, y] > 0) return false;
        board[x, y] = n;
        if (n == last) {
            if (!circular || AreNeighbors(start, current)) return true;
        }
        for (int i = 0; i < moves.Length; i++) {
            var move = moves[i];
            if (Solve(board, given, circular, size, start, last, (x + move.dx, y + move.dy), n + 1)) return true;
        }
        if (!given[n - 1]) board[x, y] = 0;
        return false;

        bool AreNeighbors((int x, int y) p1, (int x, int y) p2) => moves.Any(m => (p2.x + m.dx, p2.y + m.dy).Equals(p1));
    }

    private static (int[,] board, BitArray given, int count) Parse(string[] input)
    {
        (int height, int width) = (input.Length, input[0].Length);
        int[,] board = new int[height, width];
        int count = 0;
        for (int x = 0; x < height; x++) {
            string line = input[x];
            for (int y = 0; y < width; y++) {
                board[x, y] = y < line.Length && char.IsDigit(line[y]) ? line[y] - '0' : -1;
                if (board[x, y] >= 0) count++;
            }
        }
        BitArray given = Scan(board, count, height, width);
        return (board, given, count);
    }

    private static (int[,] board, BitArray given, int count) Parse(int[,] input)
    {
        (int height, int width) = (input.GetLength(0), input.GetLength(1));
        int[,] board = new int[height, width];
        int count = 0;
        for (int x = 0; x < height; x++)
            for (int y = 0; y < width; y++)
                if ((board[x, y] = input[x, y]) >= 0) count++;
        BitArray given = Scan(board, count, height, width);
        return (board, given, count);
    }

    private static BitArray Scan(int[,] board, int count, int height, int width)
    {
        var given = new BitArray(count + 1);
        for (int x = 0; x < height; x++)
            for (int y = 0; y < width; y++)
                if (board[x, y] > 0) given[board[x, y] - 1] = true;
        return given;
    }

    private static void Print(int[,] board)
    {
        if (board == null) {
            WriteLine("No solution");
        } else {
            int w = board.Cast<int>().Where(i => i > 0).Max(i => (int?)Ceiling(Log10(i+1))) ?? 1;
            string e = new string('-', w);
            foreach (int x in Range(0, board.GetLength(0)))
                WriteLine(string.Join(" ", Range(0, board.GetLength(1))
                    .Select(y => board[x, y] < 0 ? e : board[x, y].ToString().PadLeft(w, ' '))));
        }
        WriteLine();
    }

}
