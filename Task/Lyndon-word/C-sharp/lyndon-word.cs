using System;
using System.Collections.Generic;

public sealed class LyndonWord
{
    public static void Main(string[] args)
    {
        List<string> alphabet = new List<string> { "0", "1" };
        string word = alphabet[0];
        while (!string.IsNullOrEmpty(word))
        {
            Console.WriteLine(word);
            word = NextWord(5, word, alphabet);
        }
    }

    // Using the Duval (1988) algorithm
    private static string NextWord(int maxLength, string word, List<string> alphabet)
    {
        // Step 1: Repeat the word and truncate
        string nextWord = word;
        while (nextWord.Length < maxLength)
        {
            nextWord += word;
        }
        nextWord = nextWord.Substring(0, maxLength);

        // Step 2: Remove last symbol of the next word if it is the last symbol in the alphabet
        string alphabetLastSymbol = alphabet[alphabet.Count - 1];
        while (nextWord.EndsWith(alphabetLastSymbol))
        {
            nextWord = nextWord.Substring(0, nextWord.Length - 1);
        }

        // Step 3: Replace the last symbol of the next word by its successor in the alphabet
        if (!string.IsNullOrEmpty(nextWord))
        {
            string wordLastSymbol = nextWord.Substring(nextWord.Length - 1);
            int index = alphabet.IndexOf(wordLastSymbol) + 1;
            nextWord = nextWord.Substring(0, nextWord.Length - 1);
            nextWord += alphabet[index];
        }
        return nextWord;
    }
}
