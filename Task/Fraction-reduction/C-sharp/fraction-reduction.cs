using System;

namespace FractionReduction {
    class Program {
        static int IndexOf(int n, int[] s) {
            for (int i = 0; i < s.Length; i++) {
                if (s[i] == n) {
                    return i;
                }
            }
            return -1;
        }

        static bool GetDigits(int n, int le, int[] digits) {
            while (n > 0) {
                var r = n % 10;
                if (r == 0 || IndexOf(r, digits) >= 0) {
                    return false;
                }
                le--;
                digits[le] = r;
                n /= 10;
            }
            return true;
        }

        static int RemoveDigit(int[] digits, int le, int idx) {
            int[] pows = { 1, 10, 100, 1000, 10000 };

            var sum = 0;
            var pow = pows[le - 2];
            for (int i = 0; i < le; i++) {
                if (i == idx) continue;
                sum += digits[i] * pow;
                pow /= 10;

            }
            return sum;
        }

        static void Main() {
            var lims = new int[,] { { 12, 97 }, { 123, 986 }, { 1234, 9875 }, { 12345, 98764 } };
            var count = new int[5];
            var omitted = new int[5, 10];
            var upperBound = lims.GetLength(0);
            for (int i = 0; i < upperBound; i++) {
                var nDigits = new int[i + 2];
                var dDigits = new int[i + 2];
                var blank = new int[i + 2];
                for (int n = lims[i, 0]; n <= lims[i, 1]; n++) {
                    blank.CopyTo(nDigits, 0);
                    var nOk = GetDigits(n, i + 2, nDigits);
                    if (!nOk) {
                        continue;
                    }
                    for (int d = n + 1; d <= lims[i, 1] + 1; d++) {
                        blank.CopyTo(dDigits, 0);
                        var dOk = GetDigits(d, i + 2, dDigits);
                        if (!dOk) {
                            continue;
                        }
                        for (int nix = 0; nix < nDigits.Length; nix++) {
                            var digit = nDigits[nix];
                            var dix = IndexOf(digit, dDigits);
                            if (dix >= 0) {
                                var rn = RemoveDigit(nDigits, i + 2, nix);
                                var rd = RemoveDigit(dDigits, i + 2, dix);
                                if ((double)n / d == (double)rn / rd) {
                                    count[i]++;
                                    omitted[i, digit]++;
                                    if (count[i] <= 12) {
                                        Console.WriteLine("{0}/{1} = {2}/{3} by omitting {4}'s", n, d, rn, rd, digit);
                                    }
                                }
                            }
                        }
                    }
                }
                Console.WriteLine();
            }

            for (int i = 2; i <= 5; i++) {
                Console.WriteLine("There are {0} {1}-digit fractions of which:", count[i - 2], i);
                for (int j = 1; j <= 9; j++) {
                    if (omitted[i - 2, j] == 0) {
                        continue;
                    }
                    Console.WriteLine("{0,6} have {1}'s omitted", omitted[i - 2, j], j);
                }
                Console.WriteLine();
            }
        }
    }
}
