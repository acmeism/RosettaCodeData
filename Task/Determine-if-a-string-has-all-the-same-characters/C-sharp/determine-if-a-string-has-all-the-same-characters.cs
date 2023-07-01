using System;

namespace AllSame {
    class Program {
        static void Analyze(string s) {
            Console.WriteLine("Examining [{0}] which has a length of {1}:", s, s.Length);
            if (s.Length > 1) {
                var b = s[0];
                for (int i = 1; i < s.Length; i++) {
                    var c = s[i];
                    if (c != b) {
                        Console.WriteLine("    Not all characters in the string are the same.");
                        Console.WriteLine("    '{0}' (0x{1:X02}) is different at position {2}", c, (int)c, i);
                        return;
                    }
                }

            }
            Console.WriteLine("    All characters in the string are the same.");
        }

        static void Main() {
            var strs = new string[] { "", "   ", "2", "333", ".55", "tttTTT", "4444 444k" };
            foreach (var str in strs) {
                Analyze(str);
            }
        }
    }
}
