using System;
class ColumnAlignerProgram
{
    delegate string Justification(string s, int width);

    static string[] AlignColumns(string[] lines, Justification justification)
    {
        const char Separator = '$';
        // build input table and calculate columns count
        string[][] table = new string[lines.Length][];
        int columns = 0;
        for (int i = 0; i < lines.Length; i++)
        {
            string[] row = lines[i].TrimEnd(Separator).Split(Separator);
            if (columns < row.Length) columns = row.Length;
            table[i] = row;
        }
        // create formatted table
        string[][] formattedTable = new string[table.Length][];
        for (int i = 0; i < formattedTable.Length; i++)
        {
            formattedTable[i] = new string[columns];
        }
        for (int j = 0; j < columns; j++)
        {
            // get max column width
            int columnWidth = 0;
            for (int i = 0; i < table.Length; i++)
            {
                if (j < table[i].Length && columnWidth < table[i][j].Length)
                    columnWidth = table[i][j].Length;
            }
            // justify column cells
            for (int i = 0; i < formattedTable.Length; i++)
            {
                if (j < table[i].Length)
                    formattedTable[i][j] = justification(table[i][j], columnWidth);
                else
                    formattedTable[i][j] = new String(' ', columnWidth);
            }
        }
        // create result
        string[] result = new string[formattedTable.Length];
        for (int i = 0; i < result.Length; i++)
        {
            result[i] = String.Join(" ", formattedTable[i]);
        }
        return result;
    }

    static string JustifyLeft(string s, int width) { return s.PadRight(width); }
    static string JustifyRight(string s, int width) { return s.PadLeft(width); }
    static string JustifyCenter(string s, int width)
    {
        return s.PadLeft((width + s.Length) / 2).PadRight(width);
    }

    static void Main()
    {
        string[] input = {
            "Given$a$text$file$of$many$lines,$where$fields$within$a$line$",
            "are$delineated$by$a$single$'dollar'$character,$write$a$program",
            "that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$",
            "column$are$separated$by$at$least$one$space.",
            "Further,$allow$for$each$word$in$a$column$to$be$either$left$",
            "justified,$right$justified,$or$center$justified$within$its$column.",
        };

        foreach (string line in AlignColumns(input, JustifyCenter))
        {
            Console.WriteLine(line);
        }
    }
}
