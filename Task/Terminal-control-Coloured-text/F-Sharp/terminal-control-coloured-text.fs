open System

Console.ForegroundColor <- ConsoleColor.Red
Console.BackgroundColor <- ConsoleColor.Yellow
Console.WriteLine("Red on Yellow")

Console.ForegroundColor <- ConsoleColor.White
Console.BackgroundColor <- ConsoleColor.Black
Console.WriteLine("White on Black")

Console.ForegroundColor <- ConsoleColor.Green
Console.BackgroundColor <- ConsoleColor.Blue
Console.WriteLine("Green on Blue")

Console.ResetColor()
Console.WriteLine("Back to normal")
Console.ReadKey()
