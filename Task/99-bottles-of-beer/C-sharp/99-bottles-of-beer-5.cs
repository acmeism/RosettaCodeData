class songs
{
    static void Main(string[] args)
    {
        beer(3);
    }

    private static void beer(int bottles)
    {
        for (int i = bottles; i > 0; i--)
        {
            if (i > 1)
            {
                Console.Write("{0}\n{1}\n{2}\n{3}\n\n",
                    i + " bottles of beer on the wall",
                    i + " bottles of beer",
                    "Take one down, pass it around",
                    (i - 1) + " bottles of beer on the wall");
            }
            else
                Console.Write("{0}\n{1}\n{2}\n{3}\n\n",
                    i + " bottle of beer on the wall",
                    i + " bottle of beer",
                    "Take one down, pass it around",
                    (i - 1) + " bottles of beer on the wall....");
        }
    }
}
