static void Main(string[] args)
{
    int numBottles = 99;
    while (numBottles > 0)
    {
        if (numBottles > 1)
        {
            WriteLine("{0} bottles of beer on the wall, {0} bottles of beer.", numBottles);
            numBottles -= 1;
            WriteLine("Take one down, pass it around, {0} bottles of beer on the wall.\n", numBottles);
        }
        else
        {
            WriteLine("{0} bottle of beer on the wall, {0} bottle of beer.", numBottles);
            numBottles -= 1;
            WriteLine("Take one down, pass it around, no more bottles of beer on the wall.\n");
        }
    }
    WriteLine("No more bottles of beer on the wall, no more bottles of beer.");
    WriteLine("Go to the store to buy some more, 99 bottles of beer on the wall...");
}
