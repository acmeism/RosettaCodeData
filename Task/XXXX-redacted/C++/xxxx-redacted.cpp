#include <iostream>

using namespace std;

string redact(const string &source, const string &word, bool partial, bool insensitive, bool overkill) {
    string temp = source;

    auto different = [insensitive](char s, char w) {
        if (insensitive) {
            return toupper(s) != toupper(w);
        } else {
            return s != w;
        }
    };

    auto isWordChar = [](char c) {
        return c == '-' || isalpha(c);
    };

    for (size_t i = 0; i < temp.length() - word.length() + 1; i++) {
        bool match = true;
        for (size_t j = 0; j < word.length(); j++) {
            if (different(temp[i + j], word[j])) {
                match = false;
                break;
            }
        }
        if (match) {
            auto beg = i;
            auto end = i + word.length();

            if (!partial) {
                if (beg > 0 && isWordChar(temp[beg - 1])) {
                    continue;
                }
                if (end < temp.length() && isWordChar(temp[end])) {
                    continue;
                }
            }
            if (overkill) {
                while (beg > 0 && isWordChar(temp[beg - 1])) {
                    beg--;
                }
                while (end < temp.length() && isWordChar(temp[end])) {
                    end++;
                }
            }

            for (size_t k = beg; k < end; k++) {
                temp[k] = 'X';
            }
        }
    }

    return temp;
}

void example(const string &source, const string &word) {
    std::cout << "Redact " << word << '\n';
    std::cout << "[w|s|n] " << redact(source, word, false, false, false) << '\n';
    std::cout << "[w|i|n] " << redact(source, word, false, true, false) << '\n';
    std::cout << "[p|s|n] " << redact(source, word, true, false, false) << '\n';
    std::cout << "[p|i|n] " << redact(source, word, true, true, false) << '\n';
    std::cout << "[p|s|o] " << redact(source, word, true, false, true) << '\n';
    std::cout << "[p|i|o] " << redact(source, word, true, true, true) << '\n';
    std::cout << '\n';
}

int main() {
    string text = "Tom? Toms bottom tomato is in his stomach while playing the \"Tom-tom\" brand tom-toms. That's so tom";
    example(text, "Tom");
    example(text, "tom");
    return 0;
}
