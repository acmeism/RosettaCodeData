using System;
using System.Text;

public class FloydsTriangle
{
    internal static void Main(string[] args)
    {
        int count;
        if (args.Length >= 1 && int.TryParse(args[0], out count) && count > 0)
        {
            Console.WriteLine(MakeTriangle(count));
        }
        else
        {
            Console.WriteLine(MakeTriangle(5));
            Console.WriteLine();
            Console.WriteLine(MakeTriangle(14));
        }
    }

    public static string MakeTriangle(int rows)
    {
        int maxValue = (rows * (rows + 1)) / 2;
        int digit = 0;
        StringBuilder output = new StringBuilder();

        for (int row = 1; row <= rows; row++)
        {
            for (int column = 0; column < row; column++)
            {
                int colMaxDigit = (maxValue - rows) + column + 1;
                if (column > 0)
                {
                    output.Append(' ');
                }

                digit++;
                output.Append(digit.ToString().PadLeft(colMaxDigit.ToString().Length));
            }

            output.AppendLine();
        }

        return output.ToString();
    }
}
