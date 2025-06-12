using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

/// <summary>
/// An implementation of the Boyer-Moore string search algorithm.
/// It finds all occurrences of a pattern in a text, performing a case-insensitive search on ASCII characters.
///
/// For all full description of the algorithm visit:
/// https://en.wikipedia.org/wiki/Boyer%E2%80%93Moore_string-search_algorithm
/// </summary>
public static class BoyerMooreStringSearch
{
    public static void Main(string[] args)
    {
        List<string> texts = new List<string>
        {
            "GCTAGCTCTACGAGTCTA",
            "GGCTATAATGCGTA",
            "there would have been a time for such a word",
            "needle need noodle needle",
            "DKnuthusesandshowsanimaginarycomputertheMIXanditsassociatedmachinecodeandassemblylanguagestoillustrate",
            "Farms grew an acre of alfalfa on the dairy's behalf, with bales of that alfalfa exchanged for milk."
        };

        List<string> patterns = new List<string> { "TCTA", "TAATAAA", "word", "needle", "put", "and", "alfalfa" };

        for (int i = 0; i < texts.Count; i++)
        {
            Console.WriteLine("text" + (i + 1) + " = " + texts[i]);
        }
        Console.WriteLine();

        for (int i = 0; i < patterns.Count; i++)
        {
            int j = (i < 5) ? i : i - 1;
            Console.WriteLine("Found \"" + patterns[i] + "\" in 'text" + (j + 1) + "' at indexes "
                + string.Join(", ", StringSearch(texts[j], patterns[i])));
        }
    }

    /// <summary>
    /// Return a list of indexes at which the given pattern matches the given text.
    /// </summary>
    private static List<int> StringSearch(string aText, string aPattern)
    {
        if (string.IsNullOrEmpty(aPattern) || string.IsNullOrEmpty(aText) || aText.Length < aPattern.Length)
        {
            return new List<int>();
        }

        List<int> matches = new List<int>();

        // Preprocessing
        List<List<int>> R = BadCharacterTable(aPattern);
        int[] L = GoodSuffixTable(aPattern);
        int[] F = FullShiftTable(aPattern);

        int k = aPattern.Length - 1; // Represents the alignment of the end of aPattern relative to aText
        int previousK = -1; // Represents the above alignment in the previous phase
        while (k < aText.Length)
        {
            int i = aPattern.Length - 1; // Index of the character to compare in aPattern
            int h = k; // Index of the character to compare in aText
            while (i >= 0 && h > previousK && aPattern[i] == aText[h])
            {
                i -= 1;
                h -= 1;
            }
            if (i == -1 || h == previousK)
            { // Match has been found
                matches.Add(k - aPattern.Length + 1);
                k += (aPattern.Length > 1) ? aPattern.Length - F[1] : 1;
            }
            else
            { // No match, shift by the maximum of the bad character and good suffix rules
                int suffixShift;
                int charShift = i - R[AlphabetIndex(aText[h])][i];
                if (i + 1 == aPattern.Length)
                { // Mismatch occurred on the first character
                    suffixShift = 1;
                }
                else if (L[i + 1] == -1)
                { // Matched suffix does not appear anywhere in aPattern
                    suffixShift = aPattern.Length - F[i + 1];
                }
                else
                { // Matched suffix appears in aPattern
                    suffixShift = aPattern.Length - 1 - L[i + 1];
                }
                int shift = Math.Max(charShift, suffixShift);
                if (shift >= i + 1)
                { // Galil's rule
                    previousK = k;
                }
                k += shift;
            }
        }
        return matches;
    }

    /// <summary>
    /// Create the shift table, F, for the given text, which is an array such that
    /// F[i] is the length of the longest suffix of, aText.substring(i), which is also a prefix of the given text.
    ///
    /// Use case: If a mismatch occurs at character index i - 1 in the pattern,
    /// the magnitude of the shift of the pattern, P, relative to the text is: P.length() - F[i].
    /// </summary>
    private static int[] FullShiftTable(string aText)
    {
        int[] F = new int[aText.Length];
        int[] Z = FundamentalPreprocess(aText);
        int longest = 0;
        Array.Reverse(Z);
        for (int i = 0; i < Z.Length; i++)
        {
            int zv = Z[i];
            if (zv == i + 1)
            {
                longest = Math.Max(zv, longest);
            }
            F[F.Length - i - 1] = longest;
        }
        return F;
    }

    /// <summary>
    /// Create the good suffix table, L, for the given text, which is an array such that
    /// L[i] = k, is the largest index in the given text, S,
    /// such that S.substring(i) matches a suffix of S.substring(0, k).
    ///
    /// Use case: If a mismatch of characters occurs at index i - 1 in the pattern, P,
    /// then a shift of magnitude, P.length() - L[i], is such that no instances of the pattern in the text are omitted.
    /// Furthermore, a suffix of P.substring(0, L[i]) matches the same substring of the text that was matched by a
    /// suffix in the pattern on the previous matching attempt.
    /// In the case that L[i] = -1, the full shift table must be used.
    /// </summary>
    private static int[] GoodSuffixTable(string aText)
    {
        int[] L = Enumerable.Repeat(-1, aText.Length).ToArray();
        string reversed = new string(aText.Reverse().ToArray());
        int[] N = FundamentalPreprocess(reversed);
        Array.Reverse(N);
        for (int j = 0; j < aText.Length - 1; j++)
        {
            int i = aText.Length - N[j];
            if (i != aText.Length)
            {
                L[i] = j;
            }
        }
        return L;
    }

    /// <summary>
    /// Create the bad character table, R, for the given text,
    /// which is a list indexed by the ASCII value of a character, C, in the given text.
    ///
    /// Use case: The entry at index i of R is a list of size: 1 + length of the given text.
    /// This inner list gives at each index j the next position at which character C will be found
    /// while traversing the given text from right to left starting from index j.
    /// </summary>
    private static List<List<int>> BadCharacterTable(string aText)
    {
        if (string.IsNullOrEmpty(aText))
        {
            return new List<List<int>>();
        }

        List<List<int>> R = Enumerable.Range(0, ALPHABET_SIZE)
            .Select(i => new List<int>(Enumerable.Repeat(-1, 1))).ToList();
        List<int> alpha = Enumerable.Repeat(-1, ALPHABET_SIZE).ToList();

        for (int i = 0; i < aText.Length; i++)
        {
            alpha[AlphabetIndex(aText[i])] = i;
            for (int j = 0; j < alpha.Count; j++)
            {
                R[j].Add(alpha[j]);
            }
        }
        return R;
    }

    /// <summary>
    /// Create the fundamental preprocess, Z, of the given text, which is an array such that
    /// Z[i] is the length of the substring of the given text beginning at index i which is also a prefix of the text.
    /// </summary>
    private static int[] FundamentalPreprocess(string aText)
    {
        if (string.IsNullOrEmpty(aText))
        {
            return new int[0];
        }
        if (aText.Length == 1)
        {
            return new int[] { 1 };
        }

        int[] Z = new int[aText.Length];
        Z[0] = aText.Length;
        Z[1] = MatchLength(aText, 0, 1);
        for (int i = 2; i <= Z[1]; i++)
        {
            Z[i] = Z[1] - i + 1;
        }

        // Define the left and right limits of the z-box
        int left = 0;
        int right = 0;
        for (int i = 2 + Z[1]; i < aText.Length; i++)
        {
            if (i <= right)
            { // i falls within existing z-box
                int k = i - left;
                int b = Z[k];
                int a = right - i + 1;
                if (b < a)
                { // b ends within existing z-box
                    Z[i] = b;
                }
                else
                { // b ends at or after the end of the z-box,
                  // an explicit match to the right of the z-box is required
                    Z[i] = a + MatchLength(aText, a, right + 1);
                    left = i;
                    right = i + Z[i] - 1;
                }
            }
            else
            { // i does not fall within existing z-box
                Z[i] = MatchLength(aText, 0, i);
                if (Z[i] > 0)
                {
                    left = i;
                    right = i + Z[i] - 1;
                }
            }
        }
        return Z;
    }

    /// <summary>
    /// Return the length of the match of the two substrings of the given text beginning at each of the given indexes.
    /// </summary>
    private static int MatchLength(string aText, int aIndexOne, int aIndexTwo)
    {
        if (aIndexOne == aIndexTwo)
        {
            return aText.Length - aIndexOne;
        }

        int matchCount = 0;
        while (aIndexOne < aText.Length && aIndexTwo < aText.Length
                && aText[aIndexOne] == aText[aIndexTwo])
        {
            matchCount += 1;
            aIndexOne += 1;
            aIndexTwo += 1;
        }
        return matchCount;
    }

    /// <summary>
    /// Return the ASCII index of the given character, if it is such, otherwise throw an illegal argument exception.
    /// </summary>
    private static int AlphabetIndex(char aChar)
    {
        int result = (int)aChar;
        if (result >= ALPHABET_SIZE)
        {
            throw new ArgumentException("Not an ASCII character:" + aChar);
        }
        return result;
    }

    /* The range of ASCII characters is 0..255, both inclusive. */
    private const int ALPHABET_SIZE = 256;
}
