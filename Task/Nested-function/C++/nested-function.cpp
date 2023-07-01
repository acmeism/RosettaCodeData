#include <iostream>
#include <string>
#include <vector>

std::vector<std::string> makeList(std::string separator) {
  auto counter = 0;
  auto makeItem = [&](std::string item) {
    return std::to_string(++counter) + separator + item;
  };
  return {makeItem("first"), makeItem("second"), makeItem("third")};
}

int main() {
  for (auto item : makeList(". "))
    std::cout << item << "\n";
}
