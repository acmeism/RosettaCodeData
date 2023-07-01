using System;
public class Program
{
    public static void Main()
    {
        (int x, int y, int z) = (77444, -12, 0);

        //Sort directly:
        if (x > y) (x, y) = (y, x);
        if (x > z) (x, z) = (z, x);
        if (y > z) (y, z) = (z, y);
        Console.WriteLine((x, y, z));

        var (a, b, c) = (
            "lions, tigers, and",
            "bears, oh my!",
            "(from the 'Wizard of OZ')");

        //Sort with generic method:
        Sort(ref a, ref b, ref c);
        Console.WriteLine((a, b, c));
    }

    public static void Sort<T>(ref T a, ref T b, ref T c)
        where T : IComparable<T>
    {
        if (a.CompareTo(b) > 0) (a, b) = (b, a);
        if (a.CompareTo(c) > 0) (a, c) = (c, a);
        if (b.CompareTo(c) > 0) (b, c) = (c, b);
    }
}
