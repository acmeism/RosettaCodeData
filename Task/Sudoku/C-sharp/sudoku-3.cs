using System.Linq;
using static System.Linq.Enumerable;
using static System.Console;
using System.IO;

namespace SodukoFastMemoBFS {
    static class Program {

        static void Main(string[] args) {
            var num = int.Parse(args[0]);
            var puzzles = File.ReadLines(@"sudoku17.txt").Take(num);
            var single = puzzles.First();

            var watch = new System.Diagnostics.Stopwatch();
            watch.Start();
            WriteLine(SudokuFastMemoBFS.Run(single).AsString());
            watch.Stop();
            WriteLine($"{single}: {watch.ElapsedMilliseconds} ms");

            WriteLine($"Doing {num} puzzles");
            var total = 0.0;
            watch.Start();
            foreach (var puzzle in puzzles) {
                watch.Reset();
                watch.Start();
                SudokuFastMemoBFS.Run(puzzle);
                watch.Stop();
                total += watch.ElapsedMilliseconds;
                Write(".");
            }
            watch.Stop();
            WriteLine($"\nPuzzles:{num}, Total:{total} ms, Average:{total / num:0.00} ms");
            ReadKey();
        }
    }
}
