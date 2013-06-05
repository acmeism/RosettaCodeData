#include <map>
#include <iostream>
#include <algorithm>
#include <vector>

int main() {
  using MyDict = std::map<std::string, int>;

  MyDict dict = {
    {"One", 1},
    {"Two", 2},
    {"Three", 7}
  };

  dict["Three"] = 3;

  std::cout << "One: " << dict["One"] << std::endl;

  // Make vector of the keys from our map
  std::vector<std::string> keys;
  std::transform(dict.begin(), dict.end(), std::back_inserter(keys),
    [](MyDict::value_type& kv) { return kv.first; });

  std::cout << "Keys: " << std::endl;
  for(auto& key: keys) std::cout << "  " << key << std::endl;

  std::cout << "Key/Value pairs: " << std::endl;
  for(auto& kv: dict) {
    std::cout << "  " << kv.first << ": " << kv.second << std::endl;
  }

  return 0;
}
