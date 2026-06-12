using System;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;
using System.Text;

namespace AruthmeticCoding {
    using Freq = Dictionary<char, long>;
    using Triple = Tuple<BigInteger, int, Dictionary<char, long>>;

    class Program {
        static Freq CumulativeFreq(Freq freq) {
            long total = 0;
            Freq cf = new Freq();
            for (int i = 0; i < 256; i++) {
                char c = (char)i;
                if (freq.ContainsKey(c)) {
                    long v = freq[c];
                    cf[c] = total;
                    total += v;
                }
            }
            return cf;
        }

        static Triple ArithmeticCoding(string str, long radix) {
            // The frequency of characters
            Freq freq = new Freq();
            foreach (char c in str) {
                if (freq.ContainsKey(c)) {
                    freq[c] += 1;
                } else {
                    freq[c] = 1;
                }
            }

            // The cumulative frequency
            Freq cf = CumulativeFreq(freq);

            // Base
            BigInteger @base = str.Length;

            // Lower bound
            BigInteger lower = 0;

            // Product of all frequencies
            BigInteger pf = 1;

            // Each term is multiplied by the product of the
            // frequencies of all previously occuring symbols
            foreach (char c in str) {
                BigInteger x = cf[c];
                lower = lower * @base + x * pf;
                pf = pf * freq[c];
            }

            // Upper bound
            BigInteger upper = lower + pf;

            int powr = 0;
            BigInteger bigRadix = radix;

            while (true) {
                pf = pf / bigRadix;
                if (pf == 0) break;
                powr++;
            }

            BigInteger diff = (upper - 1) / (BigInteger.Pow(bigRadix, powr));
            return new Triple(diff, powr, freq);
        }

        static string ArithmeticDecoding(BigInteger num, long radix, int pwr, Freq freq) {
            BigInteger powr = radix;
            BigInteger enc = num * BigInteger.Pow(powr, pwr);
            long @base = freq.Values.Sum();

            // Create the cumulative frequency table
            Freq cf = CumulativeFreq(freq);

            // Create the dictionary
            Dictionary<long, char> dict = new Dictionary<long, char>();
            foreach (char key in cf.Keys) {
                long value = cf[key];
                dict[value] = key;
            }

            // Fill the gaps in the dictionary
            long lchar = -1;
            for (long i = 0; i < @base; i++) {
                if (dict.ContainsKey(i)) {
                    lchar = dict[i];
                } else if (lchar != -1) {
                    dict[i] = (char)lchar;
                }
            }

            // Decode the input number
            StringBuilder decoded = new StringBuilder((int)@base);
            BigInteger bigBase = @base;
            for (long i = @base - 1; i >= 0; --i) {
                BigInteger pow = BigInteger.Pow(bigBase, (int)i);
                BigInteger div = enc / pow;
                char c = dict[(long)div];
                BigInteger fv = freq[c];
                BigInteger cv = cf[c];
                BigInteger diff = enc - pow * cv;
                enc = diff / fv;
                decoded.Append(c);
            }

            // Return the decoded output
            return decoded.ToString();
        }

        static void Main(string[] args) {
            long radix = 10;
            string[] strings = { "DABDDB", "DABDDBBDDBA", "ABRACADABRA", "TOBEORNOTTOBEORTOBEORNOT" };
            foreach (string str in strings) {
                Triple encoded = ArithmeticCoding(str, radix);
                string dec = ArithmeticDecoding(encoded.Item1, radix, encoded.Item2, encoded.Item3);
                Console.WriteLine("{0,-25}=> {1,19} * {2}^{3}", str, encoded.Item1, radix, encoded.Item2);
                if (str != dec) {
                    throw new Exception("\tHowever that is incorrect!");
                }
            }
        }
    }
}
