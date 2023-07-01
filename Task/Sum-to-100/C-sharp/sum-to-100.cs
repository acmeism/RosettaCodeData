using System;
using System.Collections.Generic;
using System.Linq;

class Program
{
    static void Main(string[] args)
    {
        // All unique expressions that have a plus sign in front of the 1; calculated in parallel
        var expressionsPlus = Enumerable.Range(0, (int)Math.Pow(3, 8)).AsParallel().Select(i => new Expression(i, 1));
        // All unique expressions that have a minus sign in front of the 1; calculated in parallel
        var expressionsMinus = Enumerable.Range(0, (int)Math.Pow(3, 8)).AsParallel().Select(i => new Expression(i, -1));
        var expressions = expressionsPlus.Concat(expressionsMinus);
        var results = new Dictionary<int, List<Expression>>();
        foreach (var e in expressions)
        {
            if (results.Keys.Contains(e.Value))
                results[e.Value].Add(e);
            else
                results[e.Value] = new List<Expression>() { e };
        }
        Console.WriteLine("Show all solutions that sum to 100");
        foreach (Expression e in results[100])
            Console.WriteLine("  " + e);
        Console.WriteLine("Show the sum that has the maximum number of solutions (from zero to infinity)");
        var summary = results.Keys.Select(k => new Tuple<int, int>(k, results[k].Count));
        var maxSols = summary.Aggregate((a, b) => a.Item2 > b.Item2 ? a : b);
        Console.WriteLine("  The sum " + maxSols.Item1 + " has " + maxSols.Item2 + " solutions.");
        Console.WriteLine("Show the lowest positive sum that can't be expressed (has no solutions), using the rules for this task");
        var lowestPositive = Enumerable.Range(1, int.MaxValue).First(x => !results.Keys.Contains(x));
        Console.WriteLine("  " + lowestPositive);
        Console.WriteLine("Show the ten highest numbers that can be expressed using the rules for this task (extra credit)");
        var highest = from k in results.Keys
                      orderby k descending
                      select k;
        foreach (var x in highest.Take(10))
            Console.WriteLine("  " + x);
    }
}
public enum Operations { Plus, Minus, Join };
public class Expression
{
    protected Operations[] Gaps;
    // 123456789 => there are 8 "gaps" between each number
    ///             with 3 possibilities for each gap: plus, minus, or join
    public int Value; // What this expression sums up to
    protected int _one;

    public Expression(int serial, int one)
    {
        _one = one;
        Gaps = new Operations[8];
        // This represents "serial" as a base 3 number, each Gap expression being a base-three digit
        int divisor = 2187; // == Math.Pow(3,7)
        int times;
        for (int i = 0; i < 8; i++)
        {
            times = Math.DivRem(serial, divisor, out serial);
            divisor /= 3;
            if (times == 0)
                Gaps[i] = Operations.Join;
            else if (times == 1)
                Gaps[i] = Operations.Minus;
            else
                Gaps[i] = Operations.Plus;
        }
        // go ahead and calculate the value of this expression
        // because this is going to be done in a parallel thread (save time)
        Value = Evaluate();
    }
    public override string ToString()
    {
        string ret = _one.ToString();
        for (int i = 0; i < 8; i++)
        {
            switch (Gaps[i])
            {
                case Operations.Plus:
                    ret += "+";
                    break;
                case Operations.Minus:
                    ret += "-";
                    break;
            }
            ret += (i + 2);
        }
        return ret;
    }
    private int Evaluate()
        /* Calculate what this expression equals */
    {
        var numbers = new int[9];
        int nc = 0;
        var operations = new List<Operations>();
        int a = 1;
        for (int i = 0; i < 8; i++)
        {
            if (Gaps[i] == Operations.Join)
                a = a * 10 + (i + 2);
            else
            {
                if (a > 0)
                {
                    if (nc == 0)
                        a *= _one;
                    numbers[nc++] = a;
                    a = i + 2;
                }
                operations.Add(Gaps[i]);
            }
        }
        if (nc == 0)
            a *= _one;
        numbers[nc++] = a;
        int ni = 0;
        int left = numbers[ni++];
        foreach (var operation in operations)
        {
            int right = numbers[ni++];
            if (operation == Operations.Plus)
                left = left + right;
            else
                left = left - right;
        }
        return left;
    }
}
