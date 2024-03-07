using System;

public class Program
{
    public static void Main(string[] args)
    {
        var a = new Tropical(-2);
        var b = new Tropical(-1);
        var c = new Tropical(-0.5);
        var d = new Tropical(-0.001);
        var e = new Tropical(0);
        var f = new Tropical(1.5);
        var g = new Tropical(2);
        var h = new Tropical(5);
        var i = new Tropical(7);
        var j = new Tropical(8);
        var k = new Tropical(); // Represents -Inf

        Console.WriteLine("2 x -2 = " + g.Multiply(a));
        Console.WriteLine("-0.001 + -Inf = " + d.Add(k));
        Console.WriteLine("0 x -Inf = " + e.Multiply(k));
        Console.WriteLine("1.5 + -1 = " + f.Add(b));
        Console.WriteLine("-0.5 x 0 = " + c.Multiply(e));

        Console.WriteLine();
        Console.WriteLine("5^7 = " + h.Power(7));

        Console.WriteLine();
        Console.WriteLine("5 * ( 8 + 7 ) = " + h.Multiply(j.Add(i)));
        Console.WriteLine("5 * 8 + 5 * 7 = " + h.Multiply(j).Add(h.Multiply(i)));
    }
}

public class Tropical
{
    private double? number;

    public Tropical(double number)
    {
        this.number = number;
    }

    public Tropical()
    {
        this.number = null; // Represents -Inf
    }

    public override string ToString()
    {
        return number.HasValue ? ((int)number.Value).ToString() : "-Inf";
    }

    public Tropical Add(Tropical other)
    {
        if (!number.HasValue) return other;
        if (!other.number.HasValue) return this;

        return number > other.number ? this : other;
    }

    public Tropical Multiply(Tropical other)
    {
        if (number.HasValue && other.number.HasValue)
        {
            return new Tropical(number.Value + other.number.Value);
        }

        return new Tropical();
    }

    public Tropical Power(int exponent)
    {
        if (exponent <= 0)
        {
            throw new ArgumentException("Power must be positive", nameof(exponent));
        }

        Tropical result = this;
        for (int i = 1; i < exponent; i++)
        {
            result = result.Multiply(this);
        }

        return result;
    }
}
