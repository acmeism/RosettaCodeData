using System;

namespace LCP {
    class Program {
        public static string LongestCommonPrefix(params string[] sa) {
            if (null == sa) return ""; //special case
            string ret = "";
            int idx = 0;

            while (true) {
                char thisLetter = '\0';
                foreach (var word in sa) {
                    if (idx == word.Length) {
                        // if we reached the end of a word then we are done
                        return ret;
                    }
                    if (thisLetter == '\0') {
                        // if this is the first word then note the letter we are looking for
                        thisLetter = word[idx];
                    }
                    if (thisLetter != word[idx]) {
                        return ret;
                    }
                }

                // if we haven't said we are done then this position passed
                ret += thisLetter;
                idx++;
            }
        }

        static void Main(string[] args) {
            Console.WriteLine(LongestCommonPrefix("interspecies", "interstellar", "interstate"));
            Console.WriteLine(LongestCommonPrefix("throne", "throne"));
            Console.WriteLine(LongestCommonPrefix("throne", "dungeon"));
            Console.WriteLine(LongestCommonPrefix("throne", "", "throne"));
            Console.WriteLine(LongestCommonPrefix("cheese"));
            Console.WriteLine(LongestCommonPrefix(""));
            Console.WriteLine(LongestCommonPrefix(null));
            Console.WriteLine(LongestCommonPrefix("prefix", "suffix"));
            Console.WriteLine(LongestCommonPrefix("foo", "foobar"));
        }
    }
}
