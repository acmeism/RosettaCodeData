using System;

class Program
{
    static void Main(string[] args)
    {
        string testString = "She was a soul stripper. She took my heart!";
        string removeChars = "aei";
        Console.WriteLine(RemoveCharactersFromString(testString, removeChars));
    }
}
