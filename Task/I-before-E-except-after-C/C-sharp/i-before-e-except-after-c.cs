using System;
using System.Collections.Generic;
using System.IO;

namespace IBeforeE {
    class Program {
        static bool IsOppPlausibleWord(string word) {
            if (!word.Contains("c") && word.Contains("ei")) {
                return true;
            }
            if (word.Contains("cie")) {
                return true;
            }
            return false;
        }

        static bool IsPlausibleWord(string word) {
            if (!word.Contains("c") && word.Contains("ie")) {
                return true;
            }
            if (word.Contains("cei")) {
                return true;
            }
            return false;
        }

        static bool IsPlausibleRule(string filename) {
            IEnumerable<string> wordSource = File.ReadLines(filename);
            int trueCount = 0;
            int falseCount = 0;

            foreach (string word in wordSource) {
                if (IsPlausibleWord(word)) {
                    trueCount++;
                }
                else if (IsOppPlausibleWord(word)) {
                    falseCount++;
                }
            }

            Console.WriteLine("Plausible count: {0}", trueCount);
            Console.WriteLine("Implausible count: {0}", falseCount);
            return trueCount > 2 * falseCount;
        }

        static void Main(string[] args) {
            if (IsPlausibleRule("unixdict.txt")) {
                Console.WriteLine("Rule is plausible.");
            }
            else {
                Console.WriteLine("Rule is not plausible.");
            }
        }
    }
}
