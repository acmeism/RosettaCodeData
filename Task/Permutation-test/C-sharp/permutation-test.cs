using System;
using System.Collections.Generic;

namespace PermutationTest {
    class Program {
        static readonly List<int> DATA = new List<int>{
            85, 88, 75, 66, 25, 29, 83, 39, 97,
            68, 41, 10, 49, 16, 65, 32, 92, 28, 98
        };

        static int Pick(int at, int remain, int accu, int treat) {
            if (remain == 0) {
                return (accu > treat) ? 1 : 0;
            }
            return Pick(at - 1, remain - 1, accu + DATA[at - 1], treat)
                + ((at > remain) ? Pick(at - 1, remain, accu, treat) : 0);
        }

        static void Main() {
            int treat = 0;
            double total = 1.0;
            for (int i = 0; i <= 8; i++) {
                treat += DATA[i];
            }
            for (int i = 19; i >= 11; i--) {
                total *= i;
            }
            for (int i = 9; i >= 1; --i) {
                total /= i;
            }
            int gt = Pick(19, 9, 0, treat);
            int le = (int) (total - gt);
            Console.WriteLine("<= {0}%  {1}", 100.0 * le / total, le);
            Console.WriteLine(" > {0}%  {1}", 100.0 * gt / total, gt);
        }
    }
}
