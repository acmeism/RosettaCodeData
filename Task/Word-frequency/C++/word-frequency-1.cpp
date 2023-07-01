#include <algorithm>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <iterator>
#include <string>
#include <unordered_map>
#include <vector>

int main(int ac, char** av) {
  std::ios::sync_with_stdio(false);
  int head = (ac > 1) ? std::atoi(av[1]) : 10;
  std::istreambuf_iterator<char> it(std::cin), eof;
  std::filebuf file;
  if (ac > 2) {
    if (file.open(av[2], std::ios::in), file.is_open()) {
      it = std::istreambuf_iterator<char>(&file);
    } else return std::cerr << "file " << av[2] << " open failed\n", 1;
  }
  auto alpha = [](unsigned c) { return c-'A' < 26 || c-'a' < 26; };
  auto lower = [](unsigned c) { return c | '\x20'; };
  std::unordered_map<std::string, int> counts;
  std::string word;
  for (; it != eof; ++it) {
    if (alpha(*it)) {
      word.push_back(lower(*it));
    } else if (!word.empty()) {
      ++counts[word];
      word.clear();
    }
  }
  if (!word.empty()) ++counts[word]; // if file ends w/o ws
  std::vector<std::pair<const std::string,int> const*> out;
  for (auto& count : counts) out.push_back(&count);
  std::partial_sort(out.begin(),
    out.size() < head ? out.end() : out.begin() + head,
    out.end(), [](auto const* a, auto const* b) {
      return a->second > b->second;
    });
  if (out.size() > head) out.resize(head);
  for (auto const& count : out) {
    std::cout << count->first << ' ' << count->second << '\n';
  }
  return 0;
}
