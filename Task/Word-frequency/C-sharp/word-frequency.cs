using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;

namespace WordCount {
    class Program {
        static void Main(string[] args) {
            var text = File.ReadAllText("135-0.txt").ToLower();

            var match = Regex.Match(text, "\\w+");
            Dictionary<string, int> freq = new Dictionary<string, int>();
            while (match.Success) {
                string word = match.Value;
                if (freq.ContainsKey(word)) {
                    freq[word]++;
                } else {
                    freq.Add(word, 1);
                }

                match = match.NextMatch();
            }

            Console.WriteLine("Rank  Word  Frequency");
            Console.WriteLine("====  ====  =========");
            int rank = 1;
            foreach (var elem in freq.OrderByDescending(a => a.Value).Take(10)) {
                Console.WriteLine("{0,2}    {1,-4}    {2,5}", rank++, elem.Key, elem.Value);
            }
        }
    }
}
