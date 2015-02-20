#include <bitset>
#include <iostream>
#include <limits>
#include <string>

void print_bin(unsigned int n) {
  std::string str = "0";

  if (n > 0) {
    str = std::bitset<std::numeric_limits<unsigned int>::digits>(n).to_string();
    str = str.substr(str.find('1')); // remove leading zeros
  }

  std::cout << str << '\n';
}

int main() {
  print_bin(0);
  print_bin(5);
  print_bin(50);
  print_bin(9000);
}
