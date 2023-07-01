using System;
using System.Linq;

enum Justification { Left, Center, Right }

public class Program
{
    static void Main()
    {
        string text =
@"Given$a$text$file$of$many$lines,$where$fields$within$a$line$
are$delineated$by$a$single$'dollar'$character,$write$a$program
that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$
column$are$separated$by$at$least$one$space.
Further,$allow$for$each$word$in$a$column$to$be$either$left$
justified,$right$justified,$or$center$justified$within$its$column.";

        AlignColumns(text, Justification.Left);
        Console.WriteLine();
        AlignColumns(text, Justification.Center);
        Console.WriteLine();
        AlignColumns(text, Justification.Right);
    }

    public static void AlignColumns(string text, Justification justification) =>
        AlignColumns(text.Split(Environment.NewLine), justification);

    public static void AlignColumns(string[] lines, Justification justification) =>
        AlignColumns(lines.Select(line => line.Split('$')).ToArray(), justification);

    public static void AlignColumns(string[][] table, Justification justification)
    {
        Console.WriteLine(justification + ":");
        int columns = table.Max(line => line.Length);
        var columnWidths =
            Enumerable.Range(0, columns)
            .Select(i => table.Max(line => i < line.Length ? line[i].Length : 0)
            ).ToArray();

        foreach (var line in table) {
            Console.WriteLine(string.Join(" ",
                Enumerable.Range(0, line.Length)
                .Select(i => justification switch {
                    Justification.Left => line[i].PadRight(columnWidths[i]),
                    Justification.Right => line[i].PadLeft(columnWidths[i]),
                    _ => line[i].PadLeft(columnWidths[i] / 2).PadRight(columnWidths[i])
                })
            ));
        }
    }

}
