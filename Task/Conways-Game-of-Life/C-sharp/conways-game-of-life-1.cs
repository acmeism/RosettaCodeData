using System;
using System.Text;
using System.Threading;

namespace ConwaysGameOfLife
{
    // Plays Conway's Game of Life on the console with a random initial state.
    class Program
    {
        // The delay in milliseconds between board updates.
        private const int DELAY = 50;

        // The cell colors.
        private const ConsoleColor DEAD_COLOR = ConsoleColor.White;
        private const ConsoleColor LIVE_COLOR = ConsoleColor.Black;

        // The color of the cells that are off of the board.
        private const ConsoleColor EXTRA_COLOR = ConsoleColor.Gray;

        private const char EMPTY_BLOCK_CHAR = ' ';
        private const char FULL_BLOCK_CHAR = '\u2588';

        // Holds the current state of the board.
        private static bool[,] board;

        // The dimensions of the board in cells.
        private static int width = 32;
        private static int height = 32;

        // True if cell rules can loop around edges.
        private static bool loopEdges = true;


        static void Main(string[] args)
        {
            // Use initializeRandomBoard for a larger, random board.
            initializeDemoBoard();

            initializeConsole();

            // Run the game until the Escape key is pressed.
            while (!Console.KeyAvailable || Console.ReadKey(true).Key != ConsoleKey.Escape) {
                Program.drawBoard();
                Program.updateBoard();

                // Wait for a bit between updates.
                Thread.Sleep(DELAY);
            }
        }

        // Sets up the Console.
        private static void initializeConsole()
        {
            Console.BackgroundColor = EXTRA_COLOR;
            Console.Clear();

            Console.CursorVisible = false;

            // Each cell is two characters wide.
            // Using an extra row on the bottom to prevent scrolling when drawing the board.
            int width = Math.Max(Program.width, 8) * 2 + 1;
            int height = Math.Max(Program.height, 8) + 1;
            Console.SetWindowSize(width, height);
            Console.SetBufferSize(width, height);

            Console.BackgroundColor = DEAD_COLOR;
            Console.ForegroundColor = LIVE_COLOR;
        }

        // Creates the initial board with a random state.
        private static void initializeRandomBoard()
        {
            var random = new Random();

            Program.board = new bool[Program.width, Program.height];
            for (var y = 0; y < Program.height; y++) {
                for (var x = 0; x < Program.width; x++) {
                    // Equal probability of being true or false.
                    Program.board[x, y] = random.Next(2) == 0;
                }
            }
        }

        // Creates a 3x3 board with a blinker.
        private static void initializeDemoBoard()
        {
            Program.width = 3;
            Program.height = 3;

            Program.loopEdges = false;

            Program.board = new bool[3, 3];
            Program.board[1, 0] = true;
            Program.board[1, 1] = true;
            Program.board[1, 2] = true;
        }

        // Draws the board to the console.
        private static void drawBoard()
        {
            // One Console.Write call is much faster than writing each cell individually.
            var builder = new StringBuilder();

            for (var y = 0; y < Program.height; y++) {
                for (var x = 0; x < Program.width; x++) {
                    char c = Program.board[x, y] ? FULL_BLOCK_CHAR : EMPTY_BLOCK_CHAR;

                    // Each cell is two characters wide.
                    builder.Append(c);
                    builder.Append(c);
                }
                builder.Append('\n');
            }

            // Write the string to the console.
            Console.SetCursorPosition(0, 0);
            Console.Write (builder.ToString());
        }

        // Moves the board to the next state based on Conway's rules.
        private static void updateBoard()
        {
            // A temp variable to hold the next state while it's being calculated.
            bool[,] newBoard = new bool[Program.width, Program.height];

            for (var y = 0; y < Program.height; y++) {
                for (var x = 0; x < Program.width; x++) {
                    var n = countLiveNeighbors(x, y);
                    var c = Program.board[x, y];

                    // A live cell dies unless it has exactly 2 or 3 live neighbors.
                    // A dead cell remains dead unless it has exactly 3 live neighbors.
                    newBoard[x, y] = c && (n == 2 || n == 3) || !c && n == 3;
                }
            }

            // Set the board to its new state.
            Program.board = newBoard;
        }

        // Returns the number of live neighbors around the cell at position (x,y).
        private static int countLiveNeighbors(int x, int y)
        {
            // The number of live neighbors.
            int value = 0;

            // This nested loop enumerates the 9 cells in the specified cells neighborhood.
            for (var j = -1; j <= 1; j++) {
                // If loopEdges is set to false and y+j is off the board, continue.
                if (!Program.loopEdges && y + j < 0 || y + j >= Program.height) {
                    continue;
                }

                // Loop around the edges if y+j is off the board.
                int k = (y + j + Program.height) % Program.height;

                for (var i = -1; i <= 1; i++) {
                    // If loopEdges is set to false and x+i is off the board, continue.
                    if (!Program.loopEdges && x + i < 0 || x + i >= Program.width) {
                        continue;
                    }

                    // Loop around the edges if x+i is off the board.
                    int h = (x + i + Program.width) % Program.width;

                    // Count the neighbor cell at (h,k) if it is alive.
                    value += Program.board[h, k] ? 1 : 0;
                }
            }

            // Subtract 1 if (x,y) is alive since we counted it as a neighbor.
            return value - (Program.board[x, y] ? 1 : 0);
        }
    }
}
