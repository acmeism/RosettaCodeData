using System;
using System.Linq;

class Program
{
    static bool IsBalanced(string text, char open = '[', char close = ']')
    {
        var level = 0;
        foreach (var character in text)
        {
            if (character == close)
            {
                if (level == 0)
                {
                    return false;
                }
                level--;
            }
            if (character == open)
            {
                level++;
            }
        }
        return level == 0;
    }

    static string RandomBrackets(int count, char open = '[', char close = ']')
    {
        var random = new Random();
        return string.Join(string.Empty,
                (new string(open, count) + new string(close, count)).OrderBy(c => random.Next()));
    }

    static void Main()
    {
        for (var count = 0; count < 9; count++)
        {
            var text = RandomBrackets(count);
            Console.WriteLine("\"{0}\" is {1}balanced.", text, IsBalanced(text) ? string.Empty : "not ");
        }
    }
}
