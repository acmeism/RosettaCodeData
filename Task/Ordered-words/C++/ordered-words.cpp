#include <algorithm>
#include <fstream>
#include <functional>
#include <iostream>
#include <iterator>
#include <string>
#include <vector>

// use adjacent_find to test for out-of-order letter pair
bool ordered(const std::string &word)
{
    return std::adjacent_find(word.begin(), word.end(), std::greater<char>()) == word.end();
}

int main()
{
    std::ifstream infile("unixdict.txt");
    if (!infile)
    {
        std::cerr << "Can't open word file\n";
        return -1;
    }

    std::vector<std::string> words;
    std::string word;
    int longest = 0;

    while (std::getline(infile, word))
    {
        int length = word.length();
        if (length < longest) continue; // don't test short words

        if (ordered(word))
        {
            if (length > longest)
            {
                longest = length; // set new minimum length
                words.clear(); // reset the container
            }
            words.push_back(word);
        }
    }
    std::copy(words.begin(), words.end(), std::ostream_iterator<std::string>(std::cout, "\n"));
}
