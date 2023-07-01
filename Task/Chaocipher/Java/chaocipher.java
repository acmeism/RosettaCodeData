import java.util.Arrays;

public class Chaocipher {
    private enum Mode {
        ENCRYPT,
        DECRYPT
    }

    private static final String L_ALPHABET = "HXUCZVAMDSLKPEFJRIGTWOBNYQ";
    private static final String R_ALPHABET = "PTLNBQDEOYSFAVZKGJRIHWXUMC";

    private static int indexOf(char[] a, char c) {
        for (int i = 0; i < a.length; ++i) {
            if (a[i] == c) {
                return i;
            }
        }
        return -1;
    }

    private static String exec(String text, Mode mode) {
        return exec(text, mode, false);
    }

    private static String exec(String text, Mode mode, Boolean showSteps) {
        char[] left = L_ALPHABET.toCharArray();
        char[] right = R_ALPHABET.toCharArray();
        char[] eText = new char[text.length()];
        char[] temp = new char[26];

        for (int i = 0; i < text.length(); ++i) {
            if (showSteps) {
                System.out.printf("%s  %s\n", new String(left), new String(right));
            }
            int index;
            if (mode == Mode.ENCRYPT) {
                index = indexOf(right, text.charAt(i));
                eText[i] = left[index];
            } else {
                index = indexOf(left, text.charAt(i));
                eText[i] = right[index];
            }
            if (i == text.length() - 1) {
                break;
            }

            // permute left

            if (26 - index >= 0) System.arraycopy(left, index, temp, 0, 26 - index);
            System.arraycopy(left, 0, temp, 26 - index, index);
            char store = temp[1];
            System.arraycopy(temp, 2, temp, 1, 12);
            temp[13] = store;
            left = Arrays.copyOf(temp, temp.length);

            // permute right

            if (26 - index >= 0) System.arraycopy(right, index, temp, 0, 26 - index);
            System.arraycopy(right, 0, temp, 26 - index, index);
            store = temp[0];
            System.arraycopy(temp, 1, temp, 0, 25);
            temp[25] = store;
            store = temp[2];
            System.arraycopy(temp, 3, temp, 2, 11);
            temp[13] = store;
            right = Arrays.copyOf(temp, temp.length);
        }

        return new String(eText);
    }

    public static void main(String[] args) {
        String plainText = "WELLDONEISBETTERTHANWELLSAID";
        System.out.printf("The original plaintext is : %s\n", plainText);
        System.out.println("\nThe left and right alphabets after each permutation during encryption are:");
        String cipherText = exec(plainText, Mode.ENCRYPT, true);
        System.out.printf("\nThe cipher text is : %s\n", cipherText);
        String plainText2 = exec(cipherText, Mode.DECRYPT);
        System.out.printf("\nThe recovered plaintext is : %s\n", plainText2);
    }
}
