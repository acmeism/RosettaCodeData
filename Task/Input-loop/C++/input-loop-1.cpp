#include <istream>
#include <string>
#include <vector>
#include <algorithm>
#include <iostream>
#include <iterator>

// word by word
template<class OutIt>
void read_words(std::istream& is, OutIt dest)
{
  std::string word;
  while (is >> word)
  {
    // send the word to the output iterator
    *dest = word;
  }
}

// line by line:
template<class OutIt>
void read_lines(std::istream& is, OutIt dest)
{
  std::string line;
  while (std::getline(is, line))
  {
    // store the line to the output iterator
    *dest = line;
  }
}

int main()
{
  // 1) sending words from std. in std. out (end with Return)
  read_words(std::cin,
             std::ostream_iterator<std::string>(std::cout, " "));

  // 2) appending lines from std. to vector (end with Ctrl+Z)
  std::vector<std::string> v;
  read_lines(std::cin, std::back_inserter(v));

  return 0;
}
