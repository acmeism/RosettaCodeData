using System;

/// <summary>
/// Extension methods on nullable bool.
/// </summary>
/// <remarks>
/// The operators !, & and | are predefined.
/// </remarks>
public static class NullableBoolExtension
{
    public static bool? Implies(this bool? left, bool? right)
    {
        return !left | right;
    }

    public static bool? IsEquivalentTo(this bool? left, bool? right)
    {
        return left.HasValue && right.HasValue ? left == right : default(bool?);
    }

    public static string Format(this bool? value)
    {
        return value.HasValue ? value.Value.ToString() : "Maybe";
    }
}

public class Program
{
    private static void Main()
    {
        var values = new[] { true, default(bool?), false };

        foreach (var left in values)
        {
            Console.WriteLine("¬{0} = {1}", left.Format(), (!left).Format());
            foreach (var right in values)
            {
                Console.WriteLine("{0} & {1} = {2}", left.Format(), right.Format(), (left & right).Format());
                Console.WriteLine("{0} | {1} = {2}", left.Format(), right.Format(), (left | right).Format());
                Console.WriteLine("{0} → {1} = {2}", left.Format(), right.Format(), left.Implies(right).Format());
                Console.WriteLine("{0} ≡ {1} = {2}", left.Format(), right.Format(), left.IsEquivalentTo(right).Format());
            }
        }
    }
}
