using System;
using System.Collections.Generic;
using System.Drawing;

public class BifidCipher
{
    public static void Main(string[] args)
    {
        string message1 = "ATTACKATDAWN";
        string message2 = "FLEEATONCE";
        string message3 = "The invasion will start on the first of January".ToUpper().Replace(" ", "");

        Bifid bifid1 = new Bifid(5, "ABCDEFGHIKLMNOPQRSTUVWXYZ");
        Bifid bifid2 = new Bifid(5, "BGWKZQPNDSIOAXEFCLUMTHYVR");

        RunTest(bifid1, message1);
        RunTest(bifid2, message2);
        RunTest(bifid2, message1);
        RunTest(bifid1, message2);

        Bifid bifid3 = new Bifid(6, "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789");
        RunTest(bifid3, message3);
    }

    private static void RunTest(Bifid bifid, string message)
    {
        Console.WriteLine("Using Polybius square:");
        bifid.Display();
        Console.WriteLine("Message:   " + message);
        string encrypted = bifid.Encrypt(message);
        Console.WriteLine("Encrypted: " + encrypted);
        string decrypted = bifid.Decrypt(encrypted);
        Console.WriteLine("Decrypted: " + decrypted);
        Console.WriteLine();
    }
}

public class Bifid
{
    private char[,] grid;
    private Dictionary<char, Point> coordinates = new Dictionary<char, Point>();

    public Bifid(int n, string text)
    {
        if (text.Length != n * n)
        {
            throw new ArgumentException("Incorrect length of text");
        }

        grid = new char[n, n];
        int row = 0;
        int col = 0;

        foreach (char ch in text)
        {
            grid[row, col] = ch;
            coordinates[ch] = new Point(row, col);
            col += 1;
            if (col == n)
            {
                col = 0;
                row += 1;
            }
        }

        if (n == 5)
        {
            coordinates['J'] = coordinates['I'];
        }
    }

    public string Encrypt(string text)
    {
        List<int> rowOne = new List<int>();
        List<int> rowTwo = new List<int>();

        foreach (char ch in text)
        {
            Point coordinate = coordinates[ch];
            rowOne.Add(coordinate.X);
            rowTwo.Add(coordinate.Y);
        }

        rowOne.AddRange(rowTwo);
        var result = new System.Text.StringBuilder();

        for (int i = 0; i < rowOne.Count - 1; i += 2)
        {
            result.Append(grid[rowOne[i], rowOne[i + 1]]);
        }

        return result.ToString();
    }

    public string Decrypt(string text)
    {
        List<int> row = new List<int>();

        foreach (char ch in text)
        {
            Point coordinate = coordinates[ch];
            row.Add(coordinate.X);
            row.Add(coordinate.Y);
        }

        int middle = row.Count / 2;
        List<int> rowOne = row.GetRange(0, middle);
        List<int> rowTwo = row.GetRange(middle, row.Count - middle);
        var result = new System.Text.StringBuilder();

        for (int i = 0; i < middle; i++)
        {
            result.Append(grid[rowOne[i], rowTwo[i]]);
        }

        return result.ToString();
    }

    public void Display()
    {
        for (int i = 0; i < grid.GetLength(0); i++)
        {
            for (int j = 0; j < grid.GetLength(1); j++)
            {
                Console.Write(grid[i, j] + " ");
            }
            Console.WriteLine();
        }
    }
}
