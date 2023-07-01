class Program
{
    static void Main(string[] args)
    {
        string input;
        Console.Write("Enter a series of letters: ");
        input = Console.ReadLine();
        stringCase(input);
    }

    private static void stringCase(string str)
    {
        char[] chars = str.ToCharArray();
        string newStr = "";

        foreach (char i in chars)
            if (char.IsLower(i))
                newStr += char.ToUpper(i);
            else
                newStr += char.ToLower(i);
        Console.WriteLine("Converted: {0}", newStr);
    }
}
