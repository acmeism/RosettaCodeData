#include <string>
#include <iostream>
#include <algorithm>

int main() {
  std::string s;
  std::getline(std::cin, s);
  std::reverse(s.begin(), s.end()); // modifies s
  std::cout << s << '\n';
}
