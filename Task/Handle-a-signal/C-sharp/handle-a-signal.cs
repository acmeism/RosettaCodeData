using System; //DateTime, Console, Environment classes
class Program
{
    static DateTime start;
    static void Main(string[] args)
    {
        start = DateTime.Now;
        //Add event handler for Ctrl+C command
        Console.CancelKeyPress += new ConsoleCancelEventHandler(Console_CancelKeyPress);
        int counter = 0;
        while (true)
        {
            Console.WriteLine(++counter);
            System.Threading.Thread.Sleep(500);
        }
    }
    static void Console_CancelKeyPress(object sender, ConsoleCancelEventArgs e)
    {
        var end = DateTime.Now;
        Console.WriteLine("This program ran for {0:000.000} seconds.", (end - start).TotalMilliseconds / 1000);
        Environment.Exit(0);
    }
}
