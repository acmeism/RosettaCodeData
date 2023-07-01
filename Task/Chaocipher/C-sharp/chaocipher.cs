using System;

namespace Chaocipher {
    enum Mode {
        ENCRYPT,
        DECRYPT,
    }

    class Program {
        const string L_ALPHABET = "HXUCZVAMDSLKPEFJRIGTWOBNYQ";
        const string R_ALPHABET = "PTLNBQDEOYSFAVZKGJRIHWXUMC";

        static string Exec(string text, Mode mode, bool showSteps = false) {
            char[] left = L_ALPHABET.ToCharArray();
            char[] right = R_ALPHABET.ToCharArray();
            char[] eText = new char[text.Length];
            char[] temp = new char[26];

            for (int i = 0; i < text.Length; ++i) {
                if (showSteps) Console.WriteLine("{0} {1}", string.Join("", left), string.Join("", right));
                int index = 0;
                if (mode == Mode.ENCRYPT) {
                    index = Array.IndexOf(right, text[i]);
                    eText[i] = left[index];
                } else {
                    index = Array.IndexOf(left, text[i]);
                    eText[i] = right[index];
                }
                if (i == text.Length - 1) break;

                // permute left

                for (int j = index; j < 26; ++j) temp[j - index] = left[j];
                for (int j = 0; j < index; ++j) temp[26 - index + j] = left[j];
                var store = temp[1];
                for (int j = 2; j < 14; ++j) temp[j - 1] = temp[j];
                temp[13] = store;
                temp.CopyTo(left, 0);

                // permute right

                for (int j = index; j < 26; ++j) temp[j - index] = right[j];
                for (int j = 0; j < index; ++j) temp[26 - index + j] = right[j];
                store = temp[0];
                for (int j = 1; j < 26; ++j) temp[j - 1] = temp[j];
                temp[25] = store;
                store = temp[2];
                for (int j = 3; j < 14; ++j) temp[j - 1] = temp[j];
                temp[13] = store;
                temp.CopyTo(right, 0);
            }

            return new string(eText);
        }

        static void Main(string[] args) {
            var plainText = "WELLDONEISBETTERTHANWELLSAID";
            Console.WriteLine("The original plaintext is : {0}", plainText);
            Console.WriteLine("\nThe left and right alphabets after each permutation during encryption are :\n");
            var cipherText = Exec(plainText, Mode.ENCRYPT, true);
            Console.WriteLine("\nThe ciphertext is : {0}", cipherText);
            var plainText2 = Exec(cipherText, Mode.DECRYPT);
            Console.WriteLine("\nThe recovered plaintext is : {0}", plainText2);
        }
    }
}
