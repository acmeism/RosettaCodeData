using System;
using System.Collections;

namespace RosettaCode {
    class SierpinskiTriangle {
        int len;
        BitArray b;

        public SierpinskiTriangle(int n) {
            if (n < 1) {
                throw new ArgumentOutOfRangeException("Order must be greater than zero");
            }
            len = 1 << (n+1);
            b = new BitArray(len+1, false);
            b[len>>1] = true;
        }

        public void Display() {
            for (int j = 0; j < len / 2; j++) {
                for (int i = 0; i < b.Count; i++) {
                    Console.Write("{0}", b[i] ? "*" : " ");
                }
                Console.WriteLine();
                NextGen();
            }
        }

        private void NextGen() {
            BitArray next = new BitArray(b.Count, false);
            for (int i = 0; i < b.Count; i++) {
                if (b[i]) {
                    next[i - 1] = next[i - 1] ^ true;
                    next[i + 1] = next[i + 1] ^ true;
                }
            }
            b = next;
        }
    }
}
