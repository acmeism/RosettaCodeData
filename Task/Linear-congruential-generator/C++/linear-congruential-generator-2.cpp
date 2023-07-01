#include <iostream>
#include <random>

int main() {

  std::linear_congruential_engine<std::uint_fast32_t, 1103515245, 12345, 1 << 31> bsd_rand(0);
  std::linear_congruential_engine<std::uint_fast32_t, 214013, 2531011, 1 << 31> ms_rand(0);

  std::cout << "BSD RAND:" << std::endl << "========" << std::endl;
  for (int i = 0; i < 10; i++) {
    std::cout << bsd_rand() << std::endl;
  }
  std::cout << std::endl;
  std::cout << "MS RAND:" << std::endl << "========" << std::endl;
  for (int i = 0; i < 10; i++) {
    std::cout << (ms_rand() >> 16) << std::endl;
  }

  return 0;
}
