using System;
using System.Collections.Generic;
using System.Linq;

namespace Soundex
{
    internal static class Program
    {
        private static void Main()
        {
            var testWords = new TestWords
                                {
                                    {"Soundex", "S532"},
                                    {"Example", "E251"},
                                    {"Sownteks", "S532"},
                                    {"Ekzampul", "E251"},
                                    {"Euler", "E460"},
                                    {"Gauss", "G200"},
                                    {"Hilbert", "H416"},
                                    {"Knuth", "K530"},
                                    {"Lloyd", "L300"},
                                    {"Lukasiewicz", "L222"},
                                    {"Ellery", "E460"},
                                    {"Ghosh", "G200"},
                                    {"Heilbronn", "H416"},
                                    {"Kant", "K530"},
                                    {"Ladd", "L300"},
                                    {"Lissajous", "L222"},
                                    {"Wheaton", "W350"},
                                    {"Burroughs", "B620"},
                                    {"Burrows", "B620"},
                                    {"O'Hara", "O600"},
                                    {"Washington", "W252"},
                                    {"Lee", "L000"},
                                    {"Gutierrez", "G362"},
                                    {"Pfister", "P236"},
                                    {"Jackson", "J250"},
                                    {"Tymczak", "T522"},
                                    {"VanDeusen", "V532"},
                                    {"Ashcraft", "A261"}
                                };

            foreach (var testWord in testWords)
                Console.WriteLine("{0} -> {1} ({2})", testWord.Word.PadRight(11), testWord.ActualSoundex,
                                  (testWord.ExpectedSoundex == testWord.ActualSoundex));
        }

        // List<TestWord> wrapper to make declaration simpler.
        private class TestWords : List<TestWord>
        {
            public void Add(string word, string expectedSoundex)
            {
                Add(new TestWord(word, expectedSoundex));
            }
        }

        private class TestWord
        {
            public TestWord(string word, string expectedSoundex)
            {
                Word = word;
                ExpectedSoundex = expectedSoundex;
                ActualSoundex = Soundex(word);
            }

            public string Word { get; private set; }
            public string ExpectedSoundex { get; private set; }
            public string ActualSoundex { get; private set; }
        }

        private static string Soundex(string word)
        {
            const string soundexAlphabet = "0123012#02245501262301#202";
            string soundexString = "";
            char lastSoundexChar = '?';
            word = word.ToUpper();

            foreach (var c in from ch in word
                              where ch >= 'A' &&
                                    ch <= 'Z' &&
                                    soundexString.Length < 4
                              select ch)
            {
                char thisSoundexChar = soundexAlphabet[c - 'A'];

                if (soundexString.Length == 0)
                    soundexString += c;
                else if (thisSoundexChar == '#')
                    continue;
                else if (thisSoundexChar != '0' &&
                         thisSoundexChar != lastSoundexChar)
                    soundexString += thisSoundexChar;

                lastSoundexChar = thisSoundexChar;
            }

            return soundexString.PadRight(4, '0');
        }
    }
}
