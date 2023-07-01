class Test
{
    static bool valid(int n, int nuts)
    {
        for (int k = n; k != 0; k--, nuts -= 1 + nuts / n)
        {
            if (nuts % n != 1)
            {
                return false;
            }
        }

        return nuts != 0 && (nuts % n == 0);
    }

    static void Main(string[] args)
    {
        int x = 0;
        for (int n = 2; n < 10; n++)
        {
            while (!valid(n, x))
                x++;
            System.Console.WriteLine(n + ": " + x);
        }
    }
}
