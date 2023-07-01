using System;

static class Program
{
    //As an extension method (must be declared in a static class)
    static bool IsPalindrome(this string sentence)
    {
        for (int l = 0, r = sentence.Length - 1; l < r; l++, r--)
            if (sentence[l] != sentence[r]) return false;
        return true;
    }

    static void Main(string[] args)
    {
        Console.WriteLine("ingirumimusnocteetconsumimurigni".IsPalindrome());
    }
}
