using System;
using System.Collections.Generic;
using System.Numerics;
using System.Text;

namespace Base58CheckEncoding {
    class Program {
        const string ALPHABET = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";

        static BigInteger ToBigInteger(string value, int @base) {
            const string HEX = "0123456789ABCDEF";
            if (@base < 1 || @base > HEX.Length) {
                throw new ArgumentException("Base is out of range.");
            }

            BigInteger bi = BigInteger.Zero;
            foreach (char c in value) {
                char c2 = Char.ToUpper(c);
                int idx = HEX.IndexOf(c2);
                if (idx == -1 || idx >= @base) {
                    throw new ArgumentOutOfRangeException("Illegal character encountered.");
                }
                bi = bi * @base + idx;
            }

            return bi;
        }

        static string ConvertToBase58(string hash, int @base = 16) {
            BigInteger x;
            if (@base == 16 && hash.Substring(0, 2) == "0x") {
                x = ToBigInteger(hash.Substring(2), @base);
            } else {
                x = ToBigInteger(hash, @base);
            }

            StringBuilder sb = new StringBuilder();
            while (x > 0) {
                BigInteger r = x % 58;
                sb.Append(ALPHABET[(int)r]);
                x = x / 58;
            }

            char[] ca = sb.ToString().ToCharArray();
            Array.Reverse(ca);
            return new string(ca);
        }

        static void Main(string[] args) {
            string s = "25420294593250030202636073700053352635053786165627414518";
            string b = ConvertToBase58(s, 10);
            Console.WriteLine("{0} -> {1}", s, b);

            List<string> hashes = new List<string>() {
                "0x61",
                "0x626262",
                "0x636363",
                "0x73696d706c792061206c6f6e6720737472696e67",
                "0x516b6fcd0f",
                "0xbf4f89001e670274dd",
                "0x572e4794",
                "0xecac89cad93923c02321",
                "0x10c8511e",
            };
            foreach (string hash in hashes) {
                string b58 = ConvertToBase58(hash);
                Console.WriteLine("{0,-56} -> {1}", hash, b58);
            }
        }
    }
}
