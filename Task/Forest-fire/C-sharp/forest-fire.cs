using System;

namespace ForestFire
{
    internal class Program
    {
        private static void Main(string[] args)
        {
            Console.Write("Height? ");
            int height = int.Parse(Console.ReadLine());
            Console.Write("Width? ");
            int width = int.Parse(Console.ReadLine());
            Console.Write("Probability of a tree spontaneously combusting? 1/");
            int f = int.Parse(Console.ReadLine());
            Console.Write("Probability of a tree growing? 1/");
            int p = int.Parse(Console.ReadLine());
            Console.Clear();

            var state = InitializeForestFire(height, width);

            uint generation = 0;

            do
            {
                state = StepForestFire(state, f, p);

                Console.SetCursorPosition(0, 0);
                Console.ResetColor();
                Console.WriteLine("Generation " + ++generation);

                for (int y = 0; y < height; y++)
                {
                    for (int x = 0; x < width; x++)
                    {
                        switch (state[y, x])
                        {
                            case CellState.Empty:
                                Console.Write(' ');
                                break;
                            case CellState.Tree:
                                Console.ForegroundColor = ConsoleColor.DarkGreen;
                                Console.Write('T');
                                break;
                            case CellState.Burning:
                                Console.ForegroundColor = ConsoleColor.DarkRed;
                                Console.Write('F');
                                break;
                        }
                    }

                    Console.WriteLine();
                }
            } while (Console.ReadKey(true).Key != ConsoleKey.Q && generation < uint.MaxValue);
        }

        private static CellState[,] InitializeForestFire(int height, int width)
        {
            // Create our state array, initialize all indices as Empty, and return it.
            var state = new CellState[height, width];
            state.Initialize();
            return state;
        }

        private enum CellState : byte
        {
            Empty = 0,
            Tree = 1,
            Burning = 2
        }

        private static readonly Random Random = new Random();

        private static CellState[,] StepForestFire(CellState[,] state, int f, int p)
        {
            /* Clone our old state, so we can write to our new state
             * without changing any values in the old state. */
            var newState = (CellState[,]) state.Clone();

            int height = state.GetLength(0);
            int width = state.GetLength(1);

            for (int i = 1; i < height - 1; i++)
            {
                for (int o = 1; o < width - 1; o++)
                {
                    /*
                     * Check the current cell.
                     *
                     * If it's empty, give it a 1/p chance of becoming a tree.
                     *
                     * If it's a tree, check to see if any neighbors are burning.
                     * If so, set the cell's state to burning, otherwise give it
                     * a 1/f chance of combusting.
                     *
                     * If it's burning, set it to empty.
                     */
                    switch (state[i, o])
                    {
                        case CellState.Empty:
                            if (Random.Next(0, p) == 0)
                                newState[i, o] = CellState.Tree;
                            break;
                        case CellState.Tree:
                            if (IsNeighbor(state, i, o, CellState.Burning) ||
                                Random.Next(0, f) == 0)
                                newState[i, o] = CellState.Burning;
                            break;
                        case CellState.Burning:
                            newState[i, o] = CellState.Empty;
                            break;
                    }
                }
            }

            return newState;
        }

        private static bool IsNeighbor(CellState[,] state, int x, int y, CellState value)
        {
            // Check each cell within a 1 cell radius for the specified value.
            for (int i = -1; i <= 1; i++)
            {
                for (int o = -1; o <= 1; o++)
                {
                    if (i == 0 && o == 0)
                        continue;

                    if (state[x + i, y + o] == value)
                        return true;
                }
            }

            return false;
        }
    }
}
