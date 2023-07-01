#include <cctype>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <string>
#include <vector>

struct number_names {
    const char* cardinal;
    const char* ordinal;
};

const number_names small[] = {
    { "zero", "zeroth" }, { "one", "first" }, { "two", "second" },
    { "three", "third" }, { "four", "fourth" }, { "five", "fifth" },
    { "six", "sixth" }, { "seven", "seventh" }, { "eight", "eighth" },
    { "nine", "ninth" }, { "ten", "tenth" }, { "eleven", "eleventh" },
    { "twelve", "twelfth" }, { "thirteen", "thirteenth" },
    { "fourteen", "fourteenth" }, { "fifteen", "fifteenth" },
    { "sixteen", "sixteenth" }, { "seventeen", "seventeenth" },
    { "eighteen", "eighteenth" }, { "nineteen", "nineteenth" }
};

const number_names tens[] = {
    { "twenty", "twentieth" }, { "thirty", "thirtieth" },
    { "forty", "fortieth" }, { "fifty", "fiftieth" },
    { "sixty", "sixtieth" }, { "seventy", "seventieth" },
    { "eighty", "eightieth" }, { "ninety", "ninetieth" }
};

struct named_number {
    const char* cardinal;
    const char* ordinal;
    uint64_t number;
};

const named_number named_numbers[] = {
    { "hundred", "hundredth", 100 },
    { "thousand", "thousandth", 1000 },
    { "million", "millionth", 1000000 },
    { "billion", "biliionth", 1000000000 },
    { "trillion", "trillionth", 1000000000000 },
    { "quadrillion", "quadrillionth", 1000000000000000ULL },
    { "quintillion", "quintillionth", 1000000000000000000ULL }
};

const char* get_name(const number_names& n, bool ordinal) {
    return ordinal ? n.ordinal : n.cardinal;
}

const char* get_name(const named_number& n, bool ordinal) {
    return ordinal ? n.ordinal : n.cardinal;
}

const named_number& get_named_number(uint64_t n) {
    constexpr size_t names_len = std::size(named_numbers);
    for (size_t i = 0; i + 1 < names_len; ++i) {
        if (n < named_numbers[i + 1].number)
            return named_numbers[i];
    }
    return named_numbers[names_len - 1];
}

size_t append_number_name(std::vector<std::string>& result, uint64_t n, bool ordinal) {
    size_t count = 0;
    if (n < 20) {
        result.push_back(get_name(small[n], ordinal));
        count = 1;
    }
    else if (n < 100) {
        if (n % 10 == 0) {
            result.push_back(get_name(tens[n/10 - 2], ordinal));
        } else {
            std::string name(get_name(tens[n/10 - 2], false));
            name += "-";
            name += get_name(small[n % 10], ordinal);
            result.push_back(name);
        }
        count = 1;
    } else {
        const named_number& num = get_named_number(n);
        uint64_t p = num.number;
        count += append_number_name(result, n/p, false);
        if (n % p == 0) {
            result.push_back(get_name(num, ordinal));
            ++count;
        } else {
            result.push_back(get_name(num, false));
            ++count;
            count += append_number_name(result, n % p, ordinal);
        }
    }
    return count;
}

size_t count_letters(const std::string& str) {
    size_t letters = 0;
    for (size_t i = 0, n = str.size(); i < n; ++i) {
        if (isalpha(static_cast<unsigned char>(str[i])))
            ++letters;
    }
    return letters;
}

std::vector<std::string> sentence(size_t count) {
    static const char* words[] = {
        "Four", "is", "the", "number", "of", "letters", "in", "the",
        "first", "word", "of", "this", "sentence,"
    };
    std::vector<std::string> result;
    result.reserve(count + 10);
    size_t n = std::size(words);
    for (size_t i = 0; i < n && i < count; ++i) {
        result.push_back(words[i]);
    }
    for (size_t i = 1; count > n; ++i) {
        n += append_number_name(result, count_letters(result[i]), false);
        result.push_back("in");
        result.push_back("the");
        n += 2;
        n += append_number_name(result, i + 1, true);
        result.back() += ',';
    }
    return result;
}

size_t sentence_length(const std::vector<std::string>& words) {
    size_t n = words.size();
    if (n == 0)
        return 0;
    size_t length = n - 1;
    for (size_t i = 0; i < n; ++i)
        length += words[i].size();
    return length;
}

int main() {
    std::cout.imbue(std::locale(""));
    size_t n = 201;
    auto result = sentence(n);
    std::cout << "Number of letters in first " << n << " words in the sequence:\n";
    for (size_t i = 0; i < n; ++i) {
        if (i != 0)
            std::cout << (i % 25 == 0 ? '\n' : ' ');
        std::cout << std::setw(2) << count_letters(result[i]);
    }
    std::cout << '\n';
    std::cout << "Sentence length: " << sentence_length(result) << '\n';
    for (n = 1000; n <= 10000000; n *= 10) {
        result = sentence(n);
        const std::string& word = result[n - 1];
        std::cout << "The " << n << "th word is '" << word << "' and has "
            << count_letters(word) << " letters. ";
        std::cout << "Sentence length: " << sentence_length(result) << '\n';
    }
    return 0;
}
