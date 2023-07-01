#include <array>
#include <iostream>
#include <fstream>
#include <map>
#include <string>
#include <vector>
#include <boost/program_options.hpp>

// A multiset specialized for strings consisting of lowercase
// letters ('a' to 'z').
class letterset {
public:
    letterset() {
        count_.fill(0);
    }
    explicit letterset(const std::string& str) {
        count_.fill(0);
        for (char c : str)
            add(c);
    }
    bool contains(const letterset& set) const {
        for (size_t i = 0; i < count_.size(); ++i) {
            if (set.count_[i] > count_[i])
                return false;
        }
        return true;
    }
    unsigned int count(char c) const {
        return count_[index(c)];
    }
    bool is_valid() const {
        return count_[0] == 0;
    }
    void add(char c) {
        ++count_[index(c)];
    }
private:
    static bool is_letter(char c) { return c >= 'a' && c <= 'z'; }
    static int index(char c) { return is_letter(c) ? c - 'a' + 1 : 0; }
    // elements 1..26 contain the number of times each lowercase
    // letter occurs in the word
    // element 0 is the number of other characters in the word
    std::array<unsigned int, 27> count_;
};

template <typename iterator, typename separator>
std::string join(iterator begin, iterator end, separator sep) {
    std::string result;
    if (begin != end) {
        result += *begin++;
        for (; begin != end; ++begin) {
            result += sep;
            result += *begin;
        }
    }
    return result;
}

using dictionary = std::vector<std::pair<std::string, letterset>>;

dictionary load_dictionary(const std::string& filename, int min_length,
                           int max_length) {
    std::ifstream in(filename);
    if (!in)
        throw std::runtime_error("Cannot open file " + filename);
    std::string word;
    dictionary result;
    while (getline(in, word)) {
        if (word.size() < min_length)
            continue;
        if (word.size() > max_length)
            continue;
        letterset set(word);
        if (set.is_valid())
            result.emplace_back(word, set);
    }
    return result;
}

void word_wheel(const dictionary& dict, const std::string& letters,
                char central_letter)  {
    letterset set(letters);
    if (central_letter == 0 && !letters.empty())
        central_letter = letters.at(letters.size()/2);
    std::map<size_t, std::vector<std::string>> words;
    for (const auto& pair : dict) {
        const auto& word = pair.first;
        const auto& subset = pair.second;
        if (subset.count(central_letter) > 0 && set.contains(subset))
            words[word.size()].push_back(word);
    }
    size_t total = 0;
    for (const auto& p : words) {
        const auto& v = p.second;
        auto n = v.size();
        total += n;
        std::cout << "Found " << n << " " << (n == 1 ? "word" : "words")
            << " of length " << p.first << ": "
            << join(v.begin(), v.end(), ", ") << '\n';
    }
    std::cout << "Number of words found: " << total << '\n';
}

void find_max_word_count(const dictionary& dict, int word_length) {
    size_t max_count = 0;
    std::vector<std::pair<std::string, char>> max_words;
    for (const auto& pair : dict) {
        const auto& word = pair.first;
        if (word.size() != word_length)
            continue;
        const auto& set = pair.second;
        dictionary subsets;
        for (const auto& p : dict) {
            if (set.contains(p.second))
                subsets.push_back(p);
        }
        letterset done;
        for (size_t index = 0; index < word_length; ++index) {
            char central_letter = word[index];
            if (done.count(central_letter) > 0)
                continue;
            done.add(central_letter);
            size_t count = 0;
            for (const auto& p : subsets) {
                const auto& subset = p.second;
                if (subset.count(central_letter) > 0)
                    ++count;
            }
            if (count > max_count) {
                max_words.clear();
                max_count = count;
            }
            if (count == max_count)
                max_words.emplace_back(word, central_letter);
        }
    }
    std::cout << "Maximum word count: " << max_count << '\n';
    std::cout << "Words of " << word_length << " letters producing this count:\n";
    for (const auto& pair : max_words)
        std::cout << pair.first << " with central letter " << pair.second << '\n';
}

constexpr const char* option_filename = "filename";
constexpr const char* option_wheel = "wheel";
constexpr const char* option_central = "central";
constexpr const char* option_min_length = "min-length";
constexpr const char* option_part2 = "part2";

int main(int argc, char** argv) {
    const int word_length = 9;
    int min_length = 3;
    std::string letters = "ndeokgelw";
    std::string filename = "unixdict.txt";
    char central_letter = 0;
    bool do_part2 = false;

    namespace po = boost::program_options;
    po::options_description desc("Allowed options");
    desc.add_options()
        (option_filename, po::value<std::string>(), "name of dictionary file")
        (option_wheel, po::value<std::string>(), "word wheel letters")
        (option_central, po::value<char>(), "central letter (defaults to middle letter of word)")
        (option_min_length, po::value<int>(), "minimum word length")
        (option_part2, "include part 2");

    try {
        po::variables_map vm;
        po::store(po::parse_command_line(argc, argv, desc), vm);
        po::notify(vm);

        if (vm.count(option_filename))
            filename = vm[option_filename].as<std::string>();
        if (vm.count(option_wheel))
            letters = vm[option_wheel].as<std::string>();
        if (vm.count(option_central))
            central_letter = vm[option_central].as<char>();
        if (vm.count(option_min_length))
            min_length = vm[option_min_length].as<int>();
        if (vm.count(option_part2))
            do_part2 = true;

        auto dict = load_dictionary(filename, min_length, word_length);
        // part 1
        word_wheel(dict, letters, central_letter);
        // part 2
        if (do_part2) {
            std::cout << '\n';
            find_max_word_count(dict, word_length);
        }
    } catch (const std::exception& ex) {
        std::cerr << ex.what() << '\n';
        return EXIT_FAILURE;
    }
    return EXIT_SUCCESS;
}
