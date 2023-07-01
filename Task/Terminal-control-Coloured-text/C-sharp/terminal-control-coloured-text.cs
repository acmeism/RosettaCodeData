static void Main(string[] args)
{
    Console.ForegroundColor = ConsoleColor.Red;
    Console.BackgroundColor = ConsoleColor.Yellow;
    Console.WriteLine("Red on Yellow");
    Console.ForegroundColor = ConsoleColor.White;
    Console.BackgroundColor = ConsoleColor.Black;
    Console.WriteLine("White on black");
    Console.ResetColor();
    Console.WriteLine("Back to normal");
    Console.ReadKey();
}
