static void Main(string[] args)
{
    Console.Write("At the end of this line you will see the cursor, process will sleep for 5 seconds.");
    System.Threading.Thread.Sleep(5000);
    Console.CursorVisible = false;
    Console.WriteLine();
    Console.Write("At the end of this line you will not see the cursor, process will sleep for 5 seconds.");
    System.Threading.Thread.Sleep(5000);
}
