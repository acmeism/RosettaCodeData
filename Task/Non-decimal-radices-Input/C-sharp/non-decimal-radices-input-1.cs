using System;

class Program
{
    static void Main()
    {
        var value = "100";
        var fromBases = new[] { 2, 8, 10, 16 };
        var toBase = 10;
        foreach (var fromBase in fromBases)
        {
            Console.WriteLine("{0} in base {1} is {2} in base {3}",
                value, fromBase, Convert.ToInt32(value, fromBase), toBase);
        }
    }
}
