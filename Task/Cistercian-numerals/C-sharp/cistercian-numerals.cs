// Cistercian numerals
using System;

public struct Canvas
{
    private readonly char[,] _cells;
    public int Size { get; }

    public Canvas(int size)
    {
        Size = size;
        _cells = new char[Size, Size];
        Clear();
    }

    public void Clear()
    {
        for (int i = 0; i < Size; i++)
            for (int j = 0; j < Size; j++)
                _cells[i, j] = ' ';
    }

    // Draws a straight line (vertical, horizontal, or diagonal)
    // from cells[r0, c0] to cells[r0 + dr * dist, c0 + dc * dist].
    public void DrawLine(int r0, int c0, int dist, int dr, int dc)
    {
        for (int i = 0; i <= dist; i++)
        {
            int r = r0 + dr * i;
            int c = c0 + dc * i;

            if (r >= 0 && r < Size && c >= 0 && c < Size) // Check bounds
                _cells[r, c] = '*';
        }
    }

    public void Show()
    {
        for (int i = 0; i < Size; i++)
        {
            for (int j = 0; j < Size; j++)
                Console.Write(_cells[i, j]);
            Console.WriteLine();
        }
    }
}

public static class Numerals
{
    // Draws the Cistercian numeral 'number' on the 'canvas'.
    public static void DrawNumber(Canvas canvas, uint number)
    {
        int rAxis = (canvas.Size - 1) / 2; // Horizontal axis position
        int cAxis = 5; // Vertical axis position

        // Draw vertical axis
        canvas.DrawLine(0, cAxis, canvas.Size - 1, 1, 0);

        byte thousands = (byte)(number / 1000);
        number %= 1000;
        byte hundreds = (byte)(number / 100);
        number %= 100;
        byte tens = (byte)(number / 10);
        byte ones = (byte)(number % 10);

        // Draw digits in their respective quadrants
        if (thousands > 0)
            DrawDigit(canvas, thousands, rAxis, cAxis, 1, -1); // Top left
        if (hundreds > 0)
            DrawDigit(canvas, hundreds, rAxis, cAxis, 1, 1);  // Top right
        if (tens > 0)
            DrawDigit(canvas, tens, rAxis, cAxis, -1, -1);    // Bottom left
        if (ones > 0)
            DrawDigit(canvas, ones, rAxis, cAxis, -1, 1);      // Bottom right
    }


    // Draws the digit 'v' in the appropriate quadrant, determined by 'rs' and 'cs'.
    // rs, cs are signs (1 or -1) for rows and columns relative to the axes.
    private static void DrawDigit(Canvas canvas, byte digit, int rAxis, int cAxis, int rs, int cs)
    {
        switch (digit)
        {
        case 1:
            canvas.DrawLine(rAxis + rs * 7, cAxis + cs, 4, 0, cs);
            break;
        case 2:
            canvas.DrawLine(rAxis + rs * 3, cAxis + cs, 4, 0, cs);
            break;
        case 3:
            canvas.DrawLine(rAxis + rs * 7, cAxis + cs, 4, -rs, cs);
            break;
        case 4:
            canvas.DrawLine(rAxis + rs * 3, cAxis + cs, 4, rs, cs);
            break;
        case 5:
            DrawDigit(canvas, 1, rAxis, cAxis, rs, cs);
            DrawDigit(canvas, 4, rAxis, cAxis, rs, cs);
            break;
        case 6:
            canvas.DrawLine(rAxis + rs * 3, cAxis + cs * 5, 4, rs, 0);
            break;
        case 7:
            DrawDigit(canvas, 1, rAxis, cAxis, rs, cs);
            DrawDigit(canvas, 6, rAxis, cAxis, rs, cs);
            break;
        case 8:
            DrawDigit(canvas, 2, rAxis, cAxis, rs, cs);
            DrawDigit(canvas, 6, rAxis, cAxis, rs, cs);
            break;
        case 9:
            DrawDigit(canvas, 1, rAxis, cAxis, rs, cs);
            DrawDigit(canvas, 8, rAxis, cAxis, rs, cs);
            break;
        }
    }
}

class Program
{
    public static void Test(uint n)
    {
        Console.WriteLine("{0}:", n);
        Canvas canvas = new Canvas(15);
        Numerals.DrawNumber(canvas, n);
        canvas.Show();
        Console.WriteLine();
    }

    public static void Main()
    {
        Test(0);
        Test(1);
        Test(20);
        Test(300);
        Test(4000);
        Test(5555);
        Test(6789);
        Test(9999);
    }
}
