class Program
{
    static void Main(string[] args)
    {
        double sum = Enumerable.Range(1, 1000).Sum(x => 1.0 / (x * x));

        Console.WriteLine(sum);
        Console.ReadLine();
    }
}
