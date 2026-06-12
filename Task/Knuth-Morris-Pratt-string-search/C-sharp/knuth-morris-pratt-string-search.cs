using System;
using System.Collections.Generic; // Required for List<T>
using System.Linq; // Required for string.Join on List<int>

public class KmpSearchAlgorithm
{
    // Constructs the Longest Proper Prefix Suffix (LPS) array
    // Returns an int[]
    private static int[] ConstructLPS(string pattern)
    {
        int patternLen = pattern.Length;
        if (patternLen == 0)
        {
            return new int[0]; // Return empty array
        }

        // Initialize LPS array with zeros (default for int[])
        int[] lps = new int[patternLen];
        int length = 0; // Length of the previous longest prefix suffix
        int patternIndex = 1;

        // lps[0] is always 0, so we start from index 1
        while (patternIndex < patternLen)
        {
            // C# string indexing accesses characters directly
            if (pattern[patternIndex] == pattern[length])
            {
                length++;
                lps[patternIndex] = length;
                patternIndex++;
            }
            else
            {
                if (length != 0)
                {
                    length = lps[length - 1];
                    // Do not increment patternIndex here
                }
                else
                {
                    lps[patternIndex] = 0;
                    patternIndex++;
                }
            }
        }
        return lps;
    }

    // KMP search algorithm
    // Returns a List<int> containing 0-based start indices of matches
    public static List<int> KmpSearch(string pattern, string text)
    {
        var result = new List<int>(); // Use List<int> for dynamic results
        int patternLen = pattern.Length;
        int textLen = text.Length;

        if (patternLen == 0 || textLen == 0 || patternLen > textLen)
        {
            return result; // No matches possible
        }

        int[] lps = ConstructLPS(pattern);

        int textIndex = 0;    // index for text
        int patternIndex = 0; // index for pattern

        while (textIndex < textLen)
        {
            if (pattern[patternIndex] == text[textIndex])
            {
                patternIndex++;
                textIndex++;

                if (patternIndex == patternLen)
                {
                    // Match found, record start index
                    result.Add(textIndex - patternIndex);
                    // Move patternIndex back using LPS array to find next potential match
                    patternIndex = lps[patternIndex - 1];
                }
            }
            else
            {
                // Mismatch after patternIndex matches
                if (patternIndex != 0)
                {
                    // Don't match lps[0..lps[patternIndex-1]] characters,
                    // they will match anyway
                    patternIndex = lps[patternIndex - 1];
                }
                else
                {
                    // patternIndex is 0, just move to the next character in text
                    textIndex++;
                }
            }
        }

        return result;
    }

    // Main entry point
    public static void Main(string[] args)
    {
        string[] texts = {
            "GCTAGCTCTACGAGTCTA",
            "GGCTATAATGCGTA",
            "there would have been a time for such a word",
            "needle need noodle needle",
            "InhisbookseriesTheArtofComputerProgrammingpublishedbyAddisonWesleyDKnuthusesanimaginarycomputertheMIXanditsassociatedmachinecodeandassemblylanguagestoillustratetheconceptsandalgorithmsastheyarepresented",
            "Nearby farms grew a half acre of alfalfa on the dairy's behalf, with bales of all that alfalfa exchanged for milk."
        };

        string[] patterns = { "TCTA", "TAATAAA", "word", "needle", "put", "and", "alfalfa" };

        for (int i = 0; i < texts.Length; ++i)
        {
            // Use string interpolation for easy formatting
            Console.WriteLine($"Text{i + 1} = {texts[i]}");
        }
        Console.WriteLine(); // Equivalent to std::cout << std::endl;

        for (int i = 0; i < patterns.Length; ++i)
        {
            // Translate the text index logic: j = ( i < 5 ) ? i : i - 1;
            int j = (i < 5) ? i : i - 1;

            // Basic bounds check (good practice)
            if (j >= 0 && j < texts.Length)
            {
                List<int> result = KmpSearch(patterns[i], texts[j]);
                // Use string.Join for concise list formatting
                string resultString = string.Join(", ", result);
                Console.WriteLine($"Found '{patterns[i]}' in 'Text{j + 1}' at indices [{resultString}]");
            }
            else
            {
                 Console.WriteLine($"Warning: Calculated text index {j} is out of bounds for pattern '{patterns[i]}'");
            }
        }
    }
}
