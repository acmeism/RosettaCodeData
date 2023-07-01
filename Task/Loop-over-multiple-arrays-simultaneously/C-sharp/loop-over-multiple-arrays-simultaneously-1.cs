class Program
{
    static void Main(string[] args)
    {
        char[] a = { 'a', 'b', 'c' };
        char[] b = { 'A', 'B', 'C' };
        int[] c = { 1, 2, 3 };
        int min = Math.Min(a.Length, b.Length);
        min = Math.Min(min, c.Length);
        for (int i = 0; i < min; i++)
            Console.WriteLine("{0}{1}{2}", a[i], b[i], c[i]);
    }
}
