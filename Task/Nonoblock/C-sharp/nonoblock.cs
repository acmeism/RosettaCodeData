using System;
using System.Linq;
using System.Text;

public static class Nonoblock
{
    public static void Main() {
        Positions(5, 2,1);
        Positions(5);
        Positions(10, 8);
        Positions(15, 2,3,2,3);
        Positions(5, 2,3);
    }

    public static void Positions(int cells, params int[] blocks) {
        if (cells < 0 || blocks == null || blocks.Any(b => b < 1)) throw new ArgumentOutOfRangeException();
        Console.WriteLine($"{cells} cells with [{string.Join(", ", blocks)}]");
        if (blocks.Sum() + blocks.Length - 1 > cells) {
            Console.WriteLine("No solution");
            return;
        }
        var spaces = new int[blocks.Length + 1];
        int total = -1;
        for (int i = 0; i < blocks.Length; i++) {
            total += blocks[i] + 1;
            spaces[i+1] = total;
        }
        spaces[spaces.Length - 1] = cells - 1;
        var sb = new StringBuilder(string.Join(".", blocks.Select(b => new string('#', b))).PadRight(cells, '.'));
        Iterate(sb, spaces, spaces.Length - 1, 0);
        Console.WriteLine();
    }

    private static void Iterate(StringBuilder output, int[] spaces, int index, int offset) {
        Console.WriteLine(output.ToString());
        if (index <= 0) return;
        int count = 0;
        while (output[spaces[index] - offset] != '#') {
            count++;
            output.Remove(spaces[index], 1);
            output.Insert(spaces[index-1], '.');
            spaces[index-1]++;
            Iterate(output, spaces, index - 1, 1);
        }
        if (offset == 0) return;
        spaces[index-1] -= count;
        output.Remove(spaces[index-1], count);
        output.Insert(spaces[index] - count, ".", count);
    }

}
