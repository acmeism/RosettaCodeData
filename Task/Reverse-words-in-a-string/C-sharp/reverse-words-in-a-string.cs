using System;

public class ReverseWordsInString
{
    public static void Main(string[] args)
    {
        string text = @"
            ---------- Ice and Fire ------------

            fire, in end will world the say Some
            ice. in say Some
            desire of tasted I've what From
            fire. favor who those with hold I

            ... elided paragraph last ...

            Frost Robert -----------------------
            ";

        foreach (string line in text.Split(Environment.NewLine)) {
            //Splits on any whitespace, not just spaces
            string[] words = line.Split(default(char[]), StringSplitOptions.RemoveEmptyEntries);
            Array.Reverse(words);
            WriteLine(string.Join(" ", words));
        }
    }
}
