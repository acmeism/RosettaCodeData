class Program
{
    static void Main(string[] args)
    {
        Random random = new Random();
        while (true)
        {
            int a = random.Next(20);
            Console.WriteLine(a);
            if (a == 10)
                break;
            int b = random.Next(20)
            Console.WriteLine(b);
        }

        Console.ReadLine();
    }
}
