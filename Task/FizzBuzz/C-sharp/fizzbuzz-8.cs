class Program
{
    public static string FizzBuzzIt(int n) =>
        (n % 3, n % 5) switch
        {
            (0, 0) => "FizzBuzz",
            (0, _) => "Fizz",
            (_, 0) => "Buzz",
            (_, _) => $"{n}"
        };

    static void Main(string[] args)
    {
        foreach (var n in Enumerable.Range(1, 100))
        {
            Console.WriteLine(FizzBuzzIt(n));
        }
    }
}
