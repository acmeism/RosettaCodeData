using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public class LunarArithmetic
{
    public static void Main(string[] args)
    {
        var testCases = new List<List<int>>
        {
            new List<int> { 976, 348 },
            new List<int> { 23, 321 },
            new List<int> { 232, 35 },
            new List<int> { 123, 32192, 415, 8 }
        };

        foreach (var test in testCases)
        {
            string addExpression = string.Join(" 🌙 + ", test.Select(x => x.ToString()));
            Lunar addResult = test.Select(i => new Lunar(i)).Aggregate(Lunar.ZERO, (a, b) => a.Add(b));
            Console.WriteLine($"{addExpression} = {addResult}");

            string multiplyExpression = string.Join(" 🌙 x ", test.Select(x => x.ToString()));
            Lunar multiplyResult = test.Select(i => new Lunar(i)).Aggregate(Lunar.NINE, (a, b) => a.Multiply(b));
            Console.WriteLine($"{multiplyExpression} = {multiplyResult}");
            Console.WriteLine();
        }

        Console.WriteLine("First 20 distinct lunar even numbers:");
        var evens = new SortedSet<Lunar>();
        Lunar n = Lunar.ZERO;
        while (evens.Count < 20)
        {
            evens.Add(n.Multiply(new Lunar(2)));
            n = n.Increment();
        }
        Console.WriteLine(string.Join(" ", evens.Select(x => x.ToString())));
        Console.WriteLine();

        Console.WriteLine("First 20 lunar square numbers:");
        for (int i = 0; i < 20; i++)
        {
            var lunar = new Lunar(i);
            Console.Write($"{lunar.Multiply(lunar)} ");
        }
        Console.WriteLine();
        Console.WriteLine();

        Console.WriteLine("First 20 lunar factorials:");
        Lunar factorial = new Lunar(1);
        for (int i = 1; i <= 20; i++)
        {
            factorial = factorial.Multiply(new Lunar(i));
            Console.Write($"{factorial} ");
        }
        Console.WriteLine();
        Console.WriteLine();

        Lunar current = Lunar.ZERO;
        Lunar next = Lunar.ZERO;
        while (current.Multiply(current).CompareTo(next.Multiply(next)) <= 0)
        {
            current = next;
            next = next.Increment();
        }
        Console.WriteLine($"First number whose lunar square is smaller than the previous: {next}");
    }
}

public class Lunar : IComparable<Lunar>
{
    private readonly string text;

    public Lunar(long n)
    {
        if (n < 0)
        {
            throw new ArgumentException("Argument must be a non-negative integer.");
        }
        text = n.ToString();
    }

    public Lunar Add(Lunar other)
    {
        int maxLength = Math.Max(text.Length, other.text.Length);
        string a = text.PadLeft(maxLength, '0');
        string b = other.text.PadLeft(maxLength, '0');

        var sum = new StringBuilder();
        for (int i = 0; i < a.Length; i++)
        {
            sum.Append((char)Math.Max(a[i], b[i]));
        }

        return new Lunar(long.Parse(sum.ToString()));
    }

    public Lunar Multiply(Lunar other)
    {
        Lunar result = Lunar.ZERO;
        string reversed = new string(other.text.Reverse().ToArray());

        for (int i = 0; i < reversed.Length; i++)
        {
            char digit = reversed[i];
            var row = new StringBuilder();

            for (int j = 0; j < text.Length; j++)
            {
                row.Append((char)Math.Min(text[j], digit));
            }

            row.Append(new string('0', i));
            result = result.Add(new Lunar(long.Parse(row.ToString())));
        }

        return result;
    }

    public Lunar Increment()
    {
        return new Lunar(long.Parse(text) + 1);
    }

    public int CompareTo(Lunar other)
    {
        return long.Parse(text).CompareTo(long.Parse(other.text));
    }

    public override bool Equals(object obj)
    {
        return obj is Lunar other && text.Equals(other.text);
    }

    public override int GetHashCode()
    {
        return text.GetHashCode();
    }

    public override string ToString()
    {
        return text;
    }

    public static readonly Lunar ZERO = new Lunar(0); // Additive identity
    public static readonly Lunar NINE = new Lunar(9); // Multiplicative identity
}
