using System;
using System.Collections.Generic;

public class FactorizeStringIntoLyndonWords
{
    public static void Main(string[] args)
    {
        // Create a 128 character Thue-Morse word
        string thueMorse = "0";
        for (int i = 0; i < 7; i++)
        {
            string thueMorseCopy = thueMorse;
            thueMorse = thueMorse.Replace("0", "a");
            thueMorse = thueMorse.Replace("1", "0");
            thueMorse = thueMorse.Replace("a", "1");
            thueMorse = thueMorseCopy + thueMorse;
        }

        Console.WriteLine("The Thue-Morse word to be factorised:");
        Console.WriteLine(thueMorse);

        Console.WriteLine();
        Console.WriteLine("The factors are:");
        foreach (string factor in Duval(thueMorse))
        {
            Console.WriteLine(factor);
        }
    }

    // Duval's algorithm
    private static List<string> Duval(string text)
    {
        List<string> factorisation = new List<string>();
        int i = 0;

        while (i < text.Length)
        {
            int j = i + 1;
            int k = i;

            while (j < text.Length && text[k] <= text[j])
            {
                if (text[k] < text[j])
                {
                    k = i;
                }
                else
                {
                    k += 1;
                }

                j += 1;
            }

            while (i <= k)
            {
                factorisation.Add(text.Substring(i, j - k));
                i += j - k;
            }
        }

        return factorisation;
    }
}
