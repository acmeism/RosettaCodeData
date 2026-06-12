#include <iostream>
#include <string>
#include <vector>

const std::vector<std::pair<std::string, std::string>> conditions = {
    {"Printer prints", "NNNNYYYY"},
    {"A red light is flashing", "YYNNYYNN"},
    {"Printer is recognized by computer", "NYNYNYNY"}
};

const std::vector<std::pair<std::string, std::string>> actions = {
    {"Check the power cable", "NNYNNNNN"},
    {"Check the printer-computer cable", "YNYNNNNN"},
    {"Ensure printer software is installed", "YNYNYNYN"},
    {"Check/replace ink", "YYNNNYNN"},
    {"Check for paper jam", "NYNYNNNN"},
};

int main() {
    const size_t nc = conditions.size();
    const size_t na = actions.size();
    const size_t nr = conditions[0].second.size();
    const int np = 7;

    auto answers = new bool[nc];
    std::string input;

    std::cout << "Please answer the following questions with a y or n:\n";
    for (size_t c = 0; c < nc; c++) {
        char ans;
        do {
            std::cout << conditions[c].first << "? ";

            std::getline(std::cin, input);
            ans = std::toupper(input[0]);
        } while (ans != 'Y' && ans != 'N');
        answers[c] = ans == 'Y';
    }

    std::cout << "Recommended action(s)\n";
    for (size_t r = 0; r < nr; r++) {
        for (size_t c = 0; c < nc; c++) {
            char yn = answers[c] ? 'Y' : 'N';
            if (conditions[c].second[r] != yn) {
                goto outer;
            }
        }
        if (r == np) {
            std::cout << "  None (no problem detected)\n";
        } else {
            for (auto action : actions) {
                if (action.second[r] == 'Y') {
                    std::cout << "  " << action.first << '\n';
                }
            }
        }
        break;

    outer: {}
    }

    delete[] answers;
    return 0;
}
