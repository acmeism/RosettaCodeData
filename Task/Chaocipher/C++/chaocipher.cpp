#include <iostream>

enum class Mode {
    ENCRYPT,
    DECRYPT,
};

const std::string L_ALPHABET = "HXUCZVAMDSLKPEFJRIGTWOBNYQ";
const std::string R_ALPHABET = "PTLNBQDEOYSFAVZKGJRIHWXUMC";

std::string exec(std::string text, Mode mode, bool showSteps = false) {
    auto left = L_ALPHABET;
    auto right = R_ALPHABET;
    auto eText = new char[text.size() + 1];
    auto temp = new char[27];

    memset(eText, 0, text.size() + 1);
    memset(temp, 0, 27);

    for (size_t i = 0; i < text.size(); i++) {
        if (showSteps) std::cout << left << ' ' << right << '\n';
        size_t index;
        if (mode == Mode::ENCRYPT) {
            index = right.find(text[i]);
            eText[i] = left[index];
        } else {
            index = left.find(text[i]);
            eText[i] = right[index];
        }
        if (i == text.size() - 1) break;

        // permute left

        for (int j = index; j < 26; ++j) temp[j - index] = left[j];
        for (int j = 0; j < index; ++j) temp[26 - index + j] = left[j];
        auto store = temp[1];
        for (int j = 2; j < 14; ++j) temp[j - 1] = temp[j];
        temp[13] = store;
        left = temp;

        // permurte right

        for (int j = index; j < 26; ++j) temp[j - index] = right[j];
        for (int j = 0; j < index; ++j) temp[26 - index + j] = right[j];
        store = temp[0];
        for (int j = 1; j < 26; ++j) temp[j - 1] = temp[j];
        temp[25] = store;
        store = temp[2];
        for (int j = 3; j < 14; ++j) temp[j - 1] = temp[j];
        temp[13] = store;
        right = temp;
    }

    return eText;
}

int main() {
    auto plainText = "WELLDONEISBETTERTHANWELLSAID";
    std::cout << "The original plaintext is : " << plainText << "\n\n";
    std::cout << "The left and right alphabets after each permutation during encryption are :\n";
    auto cipherText = exec(plainText, Mode::ENCRYPT, true);
    std::cout << "\nThe ciphertext is : " << cipherText << '\n';
    auto plainText2 = exec(cipherText, Mode::DECRYPT);
    std::cout << "\nThe recovered plaintext is : " << plainText2 << '\n';

    return 0;
}
