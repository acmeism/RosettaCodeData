using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace Wordseach
{
    static class Program
    {
        readonly static int[,] dirs = {{1, 0}, {0, 1}, {1, 1}, {1, -1}, {-1, 0},
            {0, -1}, {-1, -1}, {-1, 1}};

        class Grid
        {
            public char[,] Cells = new char[nRows, nCols];
            public List<string> Solutions = new List<string>();
            public int NumAttempts;
        }

        readonly static int nRows = 10;
        readonly static int nCols = 10;
        readonly static int gridSize = nRows * nCols;
        readonly static int minWords = 25;

        readonly static Random rand = new Random();

        static void Main(string[] args)
        {
            PrintResult(CreateWordSearch(ReadWords("unixdict.txt")));
        }

        private static List<string> ReadWords(string filename)
        {
            int maxLen = Math.Max(nRows, nCols);

            return System.IO.File.ReadAllLines(filename)
                .Select(s => s.Trim().ToLower())
                .Where(s => Regex.IsMatch(s, "^[a-z]{3," + maxLen + "}$"))
                .ToList();
        }

        private static Grid CreateWordSearch(List<string> words)
        {
            int numAttempts = 0;

            while (++numAttempts < 100)
            {
                words.Shuffle();

                var grid = new Grid();
                int messageLen = PlaceMessage(grid, "Rosetta Code");
                int target = gridSize - messageLen;

                int cellsFilled = 0;
                foreach (var word in words)
                {
                    cellsFilled += TryPlaceWord(grid, word);
                    if (cellsFilled == target)
                    {
                        if (grid.Solutions.Count >= minWords)
                        {
                            grid.NumAttempts = numAttempts;
                            return grid;
                        }
                        else break; // grid is full but we didn't pack enough words, start over
                    }
                }
            }
            return null;
        }

        private static int TryPlaceWord(Grid grid, string word)
        {
            int randDir = rand.Next(dirs.GetLength(0));
            int randPos = rand.Next(gridSize);

            for (int dir = 0; dir < dirs.GetLength(0); dir++)
            {
                dir = (dir + randDir) % dirs.GetLength(0);

                for (int pos = 0; pos < gridSize; pos++)
                {
                    pos = (pos + randPos) % gridSize;

                    int lettersPlaced = TryLocation(grid, word, dir, pos);
                    if (lettersPlaced > 0)
                        return lettersPlaced;
                }
            }
            return 0;
        }

        private static int TryLocation(Grid grid, string word, int dir, int pos)
        {
            int r = pos / nCols;
            int c = pos % nCols;
            int len = word.Length;

            //  check bounds
            if ((dirs[dir, 0] == 1 && (len + c) > nCols)
                    || (dirs[dir, 0] == -1 && (len - 1) > c)
                    || (dirs[dir, 1] == 1 && (len + r) > nRows)
                    || (dirs[dir, 1] == -1 && (len - 1) > r))
                return 0;

            int rr, cc, i, overlaps = 0;

            // check cells
            for (i = 0, rr = r, cc = c; i < len; i++)
            {
                if (grid.Cells[rr, cc] != 0 && grid.Cells[rr, cc] != word[i])
                {
                    return 0;
                }

                cc += dirs[dir, 0];
                rr += dirs[dir, 1];
            }

            // place
            for (i = 0, rr = r, cc = c; i < len; i++)
            {
                if (grid.Cells[rr, cc] == word[i])
                    overlaps++;
                else
                    grid.Cells[rr, cc] = word[i];

                if (i < len - 1)
                {
                    cc += dirs[dir, 0];
                    rr += dirs[dir, 1];
                }
            }

            int lettersPlaced = len - overlaps;
            if (lettersPlaced > 0)
            {
                grid.Solutions.Add($"{word,-10} ({c},{r})({cc},{rr})");
            }

            return lettersPlaced;
        }

        private static int PlaceMessage(Grid grid, string msg)
        {
            msg = Regex.Replace(msg.ToUpper(), "[^A-Z]", "");

            int messageLen = msg.Length;
            if (messageLen > 0 && messageLen < gridSize)
            {
                int gapSize = gridSize / messageLen;

                for (int i = 0; i < messageLen; i++)
                {
                    int pos = i * gapSize + rand.Next(gapSize);
                    grid.Cells[pos / nCols, pos % nCols] = msg[i];
                }
                return messageLen;
            }
            return 0;
        }

        public static void Shuffle<T>(this IList<T> list)
        {
            int n = list.Count;
            while (n > 1)
            {
                n--;
                int k = rand.Next(n + 1);
                T value = list[k];
                list[k] = list[n];
                list[n] = value;
            }
        }

        private static void PrintResult(Grid grid)
        {
            if (grid == null || grid.NumAttempts == 0)
            {
                Console.WriteLine("No grid to display");
                return;
            }
            int size = grid.Solutions.Count;

            Console.WriteLine("Attempts: " + grid.NumAttempts);
            Console.WriteLine("Number of words: " + size);

            Console.WriteLine("\n     0  1  2  3  4  5  6  7  8  9");
            for (int r = 0; r < nRows; r++)
            {
                Console.Write("\n{0}   ", r);
                for (int c = 0; c < nCols; c++)
                    Console.Write(" {0} ", grid.Cells[r, c]);
            }

            Console.WriteLine("\n");

            for (int i = 0; i < size - 1; i += 2)
            {
                Console.WriteLine("{0}   {1}", grid.Solutions[i],
                        grid.Solutions[i + 1]);
            }
            if (size % 2 == 1)
                Console.WriteLine(grid.Solutions[size - 1]);

            Console.ReadLine();
        }
    }
}
