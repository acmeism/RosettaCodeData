using System;
using System.Collections.Generic;

namespace HumbleNumbers {
    class Program {
        static bool IsHumble(int i) {
            if (i <= 1) return true;
            if (i % 2 == 0) return IsHumble(i / 2);
            if (i % 3 == 0) return IsHumble(i / 3);
            if (i % 5 == 0) return IsHumble(i / 5);
            if (i % 7 == 0) return IsHumble(i / 7);
            return false;
        }

        static void Main() {
            var limit = short.MaxValue;
            Dictionary<int, int> humble = new Dictionary<int, int>();
            var count = 0;
            var num = 1;

            while (count < limit) {
                if (IsHumble(num)) {
                    var str = num.ToString();
                    var len = str.Length;
                    if (humble.ContainsKey(len)) {
                        humble[len]++;
                    } else {
                        humble[len] = 1;
                    }
                    if (count < 50) Console.Write("{0} ", num);
                    count++;
                }
                num++;
            }
            Console.WriteLine("\n");

            Console.WriteLine("Of the first {0} humble numbers:", count);
            num = 1;
            while (num < humble.Count - 1) {
                if (humble.ContainsKey(num)) {
                    var c = humble[num];
                    Console.WriteLine("{0,5} have {1,2} digits", c, num);
                    num++;
                } else {
                    break;
                }
            }
        }
    }
}
