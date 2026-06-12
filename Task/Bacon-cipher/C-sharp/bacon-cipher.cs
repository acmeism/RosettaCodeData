using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BaconCipher {
    class Program {
        private static Dictionary<char, string> codes = new Dictionary<char, string> {
            {'a', "AAAAA" }, {'b', "AAAAB" }, {'c', "AAABA" }, {'d', "AAABB" }, {'e', "AABAA" },
            {'f', "AABAB" }, {'g', "AABBA" }, {'h', "AABBB" }, {'i', "ABAAA" }, {'j', "ABAAB" },
            {'k', "ABABA" }, {'l', "ABABB" }, {'m', "ABBAA" }, {'n', "ABBAB" }, {'o', "ABBBA" },
            {'p', "ABBBB" }, {'q', "BAAAA" }, {'r', "BAAAB" }, {'s', "BAABA" }, {'t', "BAABB" },
            {'u', "BABAA" }, {'v', "BABAB" }, {'w', "BABBA" }, {'x', "BABBB" }, {'y', "BBAAA" },
            {'z', "BBAAB" }, {' ', "BBBAA" }, // use ' ' to denote any non-letter
        };

        private static string Encode(string plainText, string message) {
            string pt = plainText.ToLower();
            StringBuilder sb = new StringBuilder();
            foreach (char c in pt) {
                if ('a' <= c && c <= 'z') sb.Append(codes[c]);
                else sb.Append(codes[' ']);
            }
            string et = sb.ToString();
            string mg = message.ToLower();  // 'A's to be in lower case, 'B's in upper case
            sb.Length = 0;
            int count = 0;
            foreach (char c in mg) {
                if ('a' <= c && c <= 'z') {
                    if (et[count] == 'A') sb.Append(c);
                    else sb.Append((char)(c - 32)); // upper case equivalent
                    count++;
                    if (count == et.Length) break;
                }
                else sb.Append(c);
            }

            return sb.ToString();
        }

        private static string Decode(string message) {
            StringBuilder sb = new StringBuilder();
            foreach (char c in message) {
                if ('a' <= c && c <= 'z') sb.Append('A');
                else if ('A' <= c && c <= 'Z') sb.Append('B');
            }
            string et = sb.ToString();
            sb.Length = 0;
            for (int i = 0; i < et.Length; i += 5) {
                string quintet = et.Substring(i, 5);
                char key = codes.Where(a => a.Value == quintet).First().Key;
                sb.Append(key);
            }
            return sb.ToString();
        }

        static void Main(string[] args) {
            string plainText = "the quick brown fox jumps over the lazy dog";
            string message = "bacon's cipher is a method of steganography created by francis bacon. " +
                "this task is to implement a program for encryption and decryption of " +
                "plaintext using the simple alphabet of the baconian cipher or some " +
                "other kind of representation of this alphabet (make anything signify anything). " +
                "the baconian alphabet may optionally be extended to encode all lower " +
                "case characters individually and/or adding a few punctuation characters " +
                "such as the space.";
            string cipherText = Encode(plainText, message);
            Console.WriteLine("Cipher text ->\n{0}", cipherText);
            string decodedText = Decode(cipherText);
            Console.WriteLine("\nHidden text ->\n{0}", decodedText);
        }
    }
}
