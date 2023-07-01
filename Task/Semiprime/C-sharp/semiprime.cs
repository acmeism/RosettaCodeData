static void Main(string[] args)
{
    //test some numbers
    for (int i = 0; i < 50; i++)
    {
        Console.WriteLine("{0}\t{1} ", i,isSemiPrime(i));
    }
    Console.ReadLine();
}

//returns true or false depending if input was considered semiprime
private static bool isSemiPrime(int c)
{
    int a = 2, b = 0;
    while (b < 3 && c != 1)
    {
        if ((c % a) == 0)
        {
            c /= a;
            b++;
        }
        else
        {
            a++;
        };
    }
    return b == 2;
}
