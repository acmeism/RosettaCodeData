public static void BottlesSong(int numberOfBottles)
{
    if (numberOfBottles > 0)
    {
        Console.WriteLine("{0} bottles of beer on the wall", numberOfBottles);
        Console.WriteLine("{0} bottles of beer ", numberOfBottles);
        Console.WriteLine("Take one down, pass it around");
        Console.WriteLine("{0} bottles of beer ", numberOfBottles - 1);
        Console.WriteLine();
        BottlesSong(--numberOfBottles);
    }
}
