using System;
using System.Linq;

public class Program
{
    public static void Main() {
        Console.WriteLine(Count("aAAbbbb", "Aa"));
        Console.WriteLine(Count("ZZ", "z"));
    }

    private static int Count(string stones, string jewels) {
        var bag = jewels.ToHashSet();
        return stones.Count(bag.Contains);
    }
}
