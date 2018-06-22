public class Program
{
    static void Main()
    {
        System.Console.WriteLine(42.ModInverse(2017));
    }
}

public static class IntExtensions
{
    public static int ModInverse(this int a, int m)
    {
        if (m == 1) return 0;
        int m0 = m;
        (int x, int y) = (1, 0);

        while (a > 1) {
            int q = a / m;
            (a, m) = (m, a % m);
            (x, y) = (y, x - q * y);
        }
        return x < 0 ? x + m0 : x;
    }
}
