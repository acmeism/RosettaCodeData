class Program
{
    static void Main(string[] args)
    {
        // Create and fill a list of number 1 to 1000

        List<double> myList = new List<double>();
        for (double i = 1; i < 1001; i++)
        {
            myList.Add(i);
        }
        // Calculate the sum of 1/x^2

        var sum = myList.Sum(x => 1/(x*x));

        Console.WriteLine(sum);
        Console.ReadLine();
    }
}
