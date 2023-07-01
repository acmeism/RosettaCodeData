public class ShortestCommonSupersequence
{
    Dictionary<(string, string), string> cache = new();

    public string scs(string x, string y)
    {
        if (x.Length == 0) return y;
        if (y.Length == 0) return x;

        if (cache.TryGetValue((x, y), out var result)) return result;

        if (x[0] == y[0])
        {
            return cache[(x, y)] = x[0] + scs(x.Substring(1), y.Substring(1));
        }

        var xr = scs(x.Substring(1), y);
        var yr = scs(x, y.Substring(1));
        if (yr.Length <= xr.Length)
        {
            return cache[(x, y)] = y[0] + yr;
        }
        else
        {
            return cache[(x, y)] = x[0] + xr;
        }
    }

    public static void Main(string[] args)
    {
        var scs = new ShortestCommonSupersequence();
        Console.WriteLine(scs.scs("abcbdab", "bdcaba"));
    }
}
