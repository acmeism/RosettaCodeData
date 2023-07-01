using System;
using System.Collections.Generic;

class Program {
    static void Main(string[] args) {
        List<string> haystack = new List<string>() { "Zig", "Zag", "Wally", "Ronald", "Bush", "Krusty", "Charlie", "Bush", "Bozo" };

        foreach (string needle in new string[] { "Washington", "Bush" }) {
            int index = haystack.IndexOf(needle);

            if (index < 0) Console.WriteLine("{0} is not in haystack",needle);
            else Console.WriteLine("{0} {1}",index,needle);
        }
    }
}
