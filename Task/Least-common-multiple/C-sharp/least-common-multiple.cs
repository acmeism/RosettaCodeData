Using System;
class Program
{
    static int gcd(int m, int n)
    {
        return n == 0 ? Math.Abs(m) : gcd(n, n % m);
    }
    static int lcm(int m, int n)
    {
        return Math.Abs(m * n) / gcd(m, n);
    }
    static void Main()
    {
        Console.WriteLine("lcm(12,18)=" + lcm(12,18));
    }
}
