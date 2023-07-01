#include <algorithm>
#include <iostream>
#include <string>

struct entry {
  std::string name;
  std::string value;
};

int main() {
  entry array[] = { { "grass", "green" }, { "snow", "white" },
                    { "sky", "blue" }, { "cherry", "red" } };

  std::cout << "Before sorting:\n";
  for (const auto &e : array) {
    std::cout << "{" << e.name << ", " << e.value << "}\n";
  }

  std::sort(std::begin(array), std::end(array),
            [](const entry & a, const entry & b) {
    return a.name < b.name;
  });

  std::cout << "After sorting:\n";
  for (const auto &e : array) {
    std::cout << "{" << e.name << ", " << e.value << "}\n";
  }
}
