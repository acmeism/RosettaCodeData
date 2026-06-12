using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace MarkovChainTextGenerator {
    class Program {
        static string Join(string a, string b) {
            return a + " " + b;
        }

        static string Markov(string filePath, int keySize, int outputSize) {
            if (keySize < 1) throw new ArgumentException("Key size can't be less than 1");

            string body;
            using (StreamReader sr = new StreamReader(filePath)) {
                body = sr.ReadToEnd();
            }
            var words = body.Split();
            if (outputSize < keySize || words.Length < outputSize) {
                throw new ArgumentException("Output size is out of range");
            }

            Dictionary<string, List<string>> dict = new Dictionary<string, List<string>>();
            for (int i = 0; i < words.Length - keySize; i++) {
                var key = words.Skip(i).Take(keySize).Aggregate(Join);
                string value;
                if (i + keySize < words.Length) {
                    value = words[i + keySize];
                } else {
                    value = "";
                }

                if (dict.ContainsKey(key)) {
                    dict[key].Add(value);
                } else {
                    dict.Add(key, new List<string>() { value });
                }
            }

            Random rand = new Random();
            List<string> output = new List<string>();
            int n = 0;
            int rn = rand.Next(dict.Count);
            string prefix = dict.Keys.Skip(rn).Take(1).Single();
            output.AddRange(prefix.Split());

            while (true) {
                var suffix = dict[prefix];
                if (suffix.Count == 1) {
                    if (suffix[0] == "") {
                        return output.Aggregate(Join);
                    }
                    output.Add(suffix[0]);
                } else {
                    rn = rand.Next(suffix.Count);
                    output.Add(suffix[rn]);
                }
                if (output.Count >= outputSize) {
                    return output.Take(outputSize).Aggregate(Join);
                }
                n++;
                prefix = output.Skip(n).Take(keySize).Aggregate(Join);
            }
        }

        static void Main(string[] args) {
            Console.WriteLine(Markov("alice_oz.txt", 3, 200));
        }
    }
}
