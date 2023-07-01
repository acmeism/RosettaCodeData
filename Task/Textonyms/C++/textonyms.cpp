#include <fstream>
#include <iostream>
#include <unordered_map>
#include <vector>

struct Textonym_Checker {
private:
    int total;
    int elements;
    int textonyms;
    int max_found;
    std::vector<std::string> max_strings;
    std::unordered_map<std::string, std::vector<std::string>> values;

    int get_mapping(std::string &result, const std::string &input)
    {
        static std::unordered_map<char, char> mapping = {
            {'A', '2'}, {'B', '2'}, {'C', '2'},
            {'D', '3'}, {'E', '3'}, {'F', '3'},
            {'G', '4'}, {'H', '4'}, {'I', '4'},
            {'J', '5'}, {'K', '5'}, {'L', '5'},
            {'M', '6'}, {'N', '6'}, {'O', '6'},
            {'P', '7'}, {'Q', '7'}, {'R', '7'}, {'S', '7'},
            {'T', '8'}, {'U', '8'}, {'V', '8'},
            {'W', '9'}, {'X', '9'}, {'Y', '9'}, {'Z', '9'}
        };

        result = input;
        for (char &c : result) {
            if (!isalnum(c)) return 0;
            if (isalpha(c)) c = mapping[toupper(c)];
        }

        return 1;
    }

public:
    Textonym_Checker() : total(0), elements(0), textonyms(0), max_found(0) { }

    ~Textonym_Checker() { }

    void add(const std::string &str) {
        std::string mapping;
        total++;

        if (!get_mapping(mapping, str)) return;

        const int num_strings = values[mapping].size();

        if (num_strings == 1) textonyms++;
        elements++;

        if (num_strings > max_found) {
            max_strings.clear();
            max_strings.push_back(mapping);
            max_found = num_strings;
        }
        else if (num_strings == max_found)
            max_strings.push_back(mapping);

        values[mapping].push_back(str);
    }

    void results(const std::string &filename) {
        std::cout << "Read " << total << " words from " << filename << "\n\n";

        std::cout << "There are " << elements << " words in " << filename;
        std::cout << " which can be represented by the digit key mapping.\n";
        std::cout << "They require " << values.size() <<
                     " digit combinations to represent them.\n";
        std::cout << textonyms << " digit combinations represent Textonyms.\n\n";
        std::cout << "The numbers mapping to the most words map to ";
        std::cout << max_found + 1 << " words each:\n";

        for (auto it1 : max_strings) {
            std::cout << '\t' << it1 << " maps to: ";
            for (auto it2 : values[it1])
                std::cout << it2 << " ";
            std::cout << '\n';
        }
        std::cout << '\n';
    }

    void match(const std::string &str) {
        auto match = values.find(str);

        if (match == values.end()) {
            std::cout << "Key '" << str << "' not found\n";
        }
        else {
            std::cout << "Key '" << str << "' matches: ";
            for (auto it : values[str])
                std::cout << it << " ";
            std::cout << '\n';
        }
    }
};

int main()
{
    auto filename = "unixdict.txt";
    std::ifstream input(filename);
    Textonym_Checker tc;

    if (input.is_open()) {
        std::string line;
        while (getline(input, line))
            tc.add(line);
    }

    input.close();

    tc.results(filename);
    tc.match("001");
    tc.match("228");
    tc.match("27484247");
    tc.match("7244967473642");
}
