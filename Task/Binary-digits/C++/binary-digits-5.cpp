#include <iostream>

std::string binary(int n) {
  return n == 0 ? "" : binary(n >> 1) + std::to_string(n & 1);
}

int main(int argc, char* argv[]) {
  for (int i = 1; i < argc; ++i) {
    std::cout << binary(std::stoi(argv[i])) << std::endl;
  }
}
