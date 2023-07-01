#include <iostream>
#include <map>
#include <string>

int main() {
  std::map<std::string, int> dict {
    {"One", 1},
    {"Two", 2},
    {"Three", 7}
  };

  dict["Three"] = 3;

  std::cout << "One: " << dict["One"] << std::endl;
  std::cout << "Key/Value pairs: " << std::endl;
  for(auto& kv: dict) {
    std::cout << "  " << kv.first << ": " << kv.second << std::endl;
  }

  return 0;
}
