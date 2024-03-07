using System;
using System.Text;

public class Maze
{
    private char[,] cells;
    private char[,] hWalls; // Horizontal walls
    private char[,] vWalls; // Vertical walls
    private Random rand = new Random();

    public Maze(int rows, int cols)
    {
        cells = new char[rows, cols];
        hWalls = new char[rows + 1, cols]; // Include walls for the bottom
        vWalls = new char[rows, cols + 1]; // Include walls for the right side

        // Initialize walls
        for (int i = 0; i < rows; i++)
        {
            for (int j = 0; j < cols; j++)
            {
                hWalls[i, j] = '-';
                vWalls[i, j] = '|';
            }
        }

        // Set the outer walls for the bottom and right
        for (int i = 0; i < cols; i++)
        {
            hWalls[rows, i] = '-';
        }
        for (int i = 0; i < rows; i++)
        {
            vWalls[i, cols] = '|';
        }
    }

    public override string ToString()
    {
        var builder = new StringBuilder();

        for (int i = 0; i < cells.GetLength(0); i++)
        {
            // Top walls
            for (int j = 0; j < cells.GetLength(1); j++)
            {
                builder.Append("+");
                builder.Append(hWalls[i, j] == '-' ? "---" : "   ");
            }
            builder.AppendLine("+");

            // Side walls and cells
            for (int j = 0; j < cells.GetLength(1); j++)
            {
                builder.Append(vWalls[i, j] == '|' ? "| " : "  ");
                char cell = cells[i, j] == '\0' ? ' ' : cells[i, j];
                builder.Append(cell + " ");
            }
            builder.AppendLine("|");
        }

        // Bottom walls
        for (int j = 0; j < cells.GetLength(1); j++)
        {
            builder.Append("+---");
        }
        builder.AppendLine("+");

        return builder.ToString();
    }

    public void Generate()
    {
        Generate(rand.Next(cells.GetLength(0)), rand.Next(cells.GetLength(1)));
    }

    private void Generate(int r, int c)
    {
        cells[r, c] = ' ';
        int[] dirs = { 0, 1, 2, 3 };
        Shuffle(dirs);

        foreach (int dir in dirs)
        {
            switch (dir)
            {
                case 0: // Up
                    if (r > 0 && cells[r - 1, c] == '\0')
                    {
                        hWalls[r, c] = ' ';
                        Generate(r - 1, c);
                    }
                    break;
                case 1: // Down
                    if (r < cells.GetLength(0) - 1 && cells[r + 1, c] == '\0')
                    {
                        hWalls[r + 1, c] = ' ';
                        Generate(r + 1, c);
                    }
                    break;
                case 2: // Right
                    if (c < cells.GetLength(1) - 1 && cells[r, c + 1] == '\0')
                    {
                        vWalls[r, c + 1] = ' ';
                        Generate(r, c + 1);
                    }
                    break;
                case 3: // Left
                    if (c > 0 && cells[r, c - 1] == '\0')
                    {
                        vWalls[r, c] = ' ';
                        Generate(r, c - 1);
                    }
                    break;
            }
        }
    }

    private void Shuffle(int[] array)
    {
        for (int i = array.Length - 1; i > 0; i--)
        {
            int j = rand.Next(i + 1);
            int temp = array[i];
            array[i] = array[j];
            array[j] = temp;
        }
    }

    public void Solve(int startRow, int startCol, int endRow, int endCol)
    {
        if (Solve(startRow, startCol, endRow, endCol, -1))
        {
            cells[startRow, startCol] = 'S';
            cells[endRow, endCol] = 'F';
        }
    }

    private bool Solve(int r, int c, int endRow, int endCol, int dir)
    {
        if (r == endRow && c == endCol) return true;

        // Up
        if (dir != 1 && r > 0 && hWalls[r, c] == ' ' && Solve(r - 1, c, endRow, endCol, 0))
        {
            cells[r, c] = '^';
            return true;
        }
        // Down
        if (dir != 0 && r < cells.GetLength(0) - 1 && hWalls[r + 1, c] == ' ' && Solve(r + 1, c, endRow, endCol, 1))
        {
            cells[r, c] = 'v';
            return true;
        }
        // Right
        if (dir != 3 && c < cells.GetLength(1) - 1 && vWalls[r, c + 1] == ' ' && Solve(r, c + 1, endRow, endCol, 2))
        {
            cells[r, c] = '>';
            return true;
        }
        // Left
        if (dir != 2 && c > 0 && vWalls[r, c] == ' ' && Solve(r, c - 1, endRow, endCol, 3))
        {
            cells[r, c] = '<';
            return true;
        }

        return false;
    }
}

class Program
{
    static void Main(string[] args)
    {
        var maze = new Maze(4, 7);
        maze.Generate();
        Random rand = new Random();
        maze.Solve(rand.Next(4), rand.Next(7), rand.Next(4), rand.Next(7));
        Console.WriteLine(maze);
    }
}
