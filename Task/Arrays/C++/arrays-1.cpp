#include <array>
#include <algorithm>
#include <iostream>

int main() {
  std::array<std::string, 3> words = {"One", "Four", "Eight"};
  words[2] = "Three";
  words.at(1) = "Two";

  std::reverse(words.begin(), words.end());

  for(auto& word: words) std::cout << word << " ";
  std::cout << std::endl;

  return 0;
}
