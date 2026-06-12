#include <iostream>
#include <map>
#include <string>

std::map<std::string, int> find_ngrams(int n, const std::string& s)
{
    std::map<std::string, int> ngrams;
    size_t max_loc = s.length() - n;
    for (size_t i = 0; i <= max_loc; i++)
        ngrams[s.substr(i, n)]++;
    return ngrams;
}

void print_ngrams(const std::map<std::string, int>& ngrams)
{
    int col = 0;
    for (const auto& [ngram, count] : ngrams) {
        std::cout << "'" << ngram << "' - " << count;
        if (col++ % 5 == 4)
            std::cout << std::endl;
        else
            std::cout << '\t';
    }
    std::cout << std::endl;
}

int main(void)
{
    std::string s("LIVE AND LET LIVE");

    for (int n=2; n<=4; n++) {
        std::cout << n << "-grams of '" << s << ":" << std::endl;
        print_ngrams(find_ngrams(n, s));
    }

    return 0;
}
