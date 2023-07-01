using System;

class SudokuSolver
{
    private int[] grid;

    public SudokuSolver(String s)
    {
        grid = new int[81];
        for (int i = 0; i < s.Length; i++)
        {
            grid[i] = int.Parse(s[i].ToString());
        }
    }

    public void solve()
    {
        try
        {
            placeNumber(0);
            Console.WriteLine("Unsolvable!");
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.Message);
            Console.WriteLine(this);
        }
    }

    public void placeNumber(int pos)
    {
        if (pos == 81)
        {
            throw new Exception("Finished!");
        }
        if (grid[pos] > 0)
        {
            placeNumber(pos + 1);
            return;
        }
        for (int n = 1; n <= 9; n++)
        {
            if (checkValidity(n, pos % 9, pos / 9))
            {
                grid[pos] = n;
                placeNumber(pos + 1);
                grid[pos] = 0;
            }
        }
    }

    public bool checkValidity(int val, int x, int y)
    {
        for (int i = 0; i < 9; i++)
        {
            if (grid[y * 9 + i] == val || grid[i * 9 + x] == val)
                return false;
        }
        int startX = (x / 3) * 3;
        int startY = (y / 3) * 3;
        for (int i = startY; i < startY + 3; i++)
        {
            for (int j = startX; j < startX + 3; j++)
            {
                if (grid[i * 9 + j] == val)
                    return false;
            }
        }
        return true;
    }

    public override string ToString()
    {
        string sb = "";
        for (int i = 0; i < 9; i++)
        {
            for (int j = 0; j < 9; j++)
            {
                sb += (grid[i * 9 + j] + " ");
                if (j == 2 || j == 5)
                    sb += ("| ");
            }
            sb += ('\n');
            if (i == 2 || i == 5)
                sb += ("------+-------+------\n");
        }
        return sb;
    }

    public static void Main(String[] args)
    {
        new SudokuSolver("850002400" +
                         "720000009" +
                         "004000000" +
                         "000107002" +
                         "305000900" +
                         "040000000" +
                         "000080070" +
                         "017000000" +
                         "000036040").solve();
        Console.Read();
    }
}
