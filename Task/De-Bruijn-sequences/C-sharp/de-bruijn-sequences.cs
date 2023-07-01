using System;
using System.Collections.Generic;
using System.Text;

namespace DeBruijn {
    class Program {
        const string digits = "0123456789";

        static string DeBruijn(int k, int n) {
            var alphabet = digits.Substring(0, k);
            var a = new byte[k * n];
            var seq = new List<byte>();
            void db(int t, int p) {
                if (t > n) {
                    if (n % p == 0) {
                        seq.AddRange(new ArraySegment<byte>(a, 1, p));
                    }
                } else {
                    a[t] = a[t - p];
                    db(t + 1, p);
                    var j = a[t - p] + 1;
                    while (j < k) {
                        a[t] = (byte)j;
                        db(t + 1, t);
                        j++;
                    }
                }
            }
            db(1, 1);
            var buf = new StringBuilder();
            foreach (var i in seq) {
                buf.Append(alphabet[i]);
            }
            var b = buf.ToString();
            return b + b.Substring(0, n - 1);
        }

        static bool AllDigits(string s) {
            foreach (var c in s) {
                if (c < '0' || '9' < c) {
                    return false;
                }
            }
            return true;
        }

        static void Validate(string db) {
            var le = db.Length;
            var found = new int[10_000];
            var errs = new List<string>();
            // Check all strings of 4 consecutive digits within 'db'
            // to see if all 10,000 combinations occur without duplication.
            for (int i = 0; i < le - 3; i++) {
                var s = db.Substring(i, 4);
                if (AllDigits(s)) {
                    int.TryParse(s, out int n);
                    found[n]++;
                }
            }
            for (int i = 0; i < 10_000; i++) {
                if (found[i] == 0) {
                    errs.Add(string.Format("    PIN number {0,4} missing", i));
                } else if (found[i] > 1) {
                    errs.Add(string.Format("    PIN number {0,4} occurs {1} times", i, found[i]));
                }
            }
            var lerr = errs.Count;
            if (lerr == 0) {
                Console.WriteLine("  No errors found");
            } else {
                var pl = lerr == 1 ? "" : "s";
                Console.WriteLine("  {0} error{1} found:", lerr, pl);
                errs.ForEach(Console.WriteLine);
            }
        }

        static string Reverse(string s) {
            char[] arr = s.ToCharArray();
            Array.Reverse(arr);
            return new string(arr);
        }

        static void Main() {
            var db = DeBruijn(10, 4);
            var le = db.Length;

            Console.WriteLine("The length of the de Bruijn sequence is {0}", le);
            Console.WriteLine("\nThe first 130 digits of the de Bruijn sequence are: {0}", db.Substring(0, 130));
            Console.WriteLine("\nThe last 130 digits of the de Bruijn sequence are: {0}", db.Substring(le - 130, 130));

            Console.WriteLine("\nValidating the deBruijn sequence:");
            Validate(db);

            Console.WriteLine("\nValidating the reversed deBruijn sequence:");
            Validate(Reverse(db));

            var bytes = db.ToCharArray();
            bytes[4443] = '.';
            db = new string(bytes);
            Console.WriteLine("\nValidating the overlaid deBruijn sequence:");
            Validate(db);
        }
    }
}
