import std.stdio;
import std.string;

immutable L_ALPHABET = "HXUCZVAMDSLKPEFJRIGTWOBNYQ";
immutable R_ALPHABET = "PTLNBQDEOYSFAVZKGJRIHWXUMC";

enum Mode {
    ENCRYPT,
    DECRYPT,
}

string exec(string text, Mode mode, bool showSteps = false) {
    char[] left = L_ALPHABET.dup;
    char[] right = R_ALPHABET.dup;
    char[] eText;
    eText.length = text.length;
    char[26] temp;

    foreach (i; 0..text.length) {
        if (showSteps) writeln(left, ' ', right);
        int index;
        if (mode == Mode.ENCRYPT) {
            index = right.indexOf(text[i]);
            eText[i] = left[index];
        } else {
            index = left.indexOf(text[i]);
            eText[i] = right[index];
        }
        if (i == text.length - 1) break;

        // permute left

        foreach (j; index..26) temp[j - index] = left[j];
        foreach (j; 0..index) temp[26 - index + j] = left[j];
        auto store = temp[1];
        foreach (j; 2..14) temp[j - 1] = temp[j];
        temp[13] = store;
        left = temp.dup;

        // permute right

        foreach (j; index..26) temp[j - index] = right[j];
        foreach (j; 0..index) temp[26 - index + j] = right[j];
        store = temp[0];
        foreach (j; 1..26) temp[j - 1] = temp[j];
        temp[25] = store;
        store = temp[2];
        foreach (j; 3..14) temp[j - 1] = temp[j];
        temp[13] = store;
        right = temp.dup;
    }

    return eText.idup;
}

void main() {
    auto plainText = "WELLDONEISBETTERTHANWELLSAID";
    writeln("The original plaintext is : ", plainText);
    writeln("\nThe left and right alphabets after each permutation during encryption are :\n");
    auto cipherText = exec(plainText, Mode.ENCRYPT, true);
    writeln("\nThe ciphertext is : ", cipherText);
    auto plainText2 = exec(cipherText, Mode.DECRYPT);
    writeln("\nThe recovered plaintext is : ", plainText2);
}
