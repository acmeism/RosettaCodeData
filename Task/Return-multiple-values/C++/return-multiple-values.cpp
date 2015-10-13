#include <algorithm>
#include <array>
#include <cstdint>
#include <iostream>
#include <tuple>

std::tuple<int, int> minmax(const int * numbers, const std::size_t num) {
   const auto maximum = std::max_element(numbers, numbers + num);
   const auto minimum = std::min_element(numbers, numbers + num);
   return std::make_tuple(*minimum, *maximum) ;
}

int main( ) {
   const auto numbers = std::array<int, 8>{{17, 88, 9, 33, 4, 987, -10, 2}};
   int min{};
   int max{};
   std::tie(min, max) = minmax(numbers.data(), numbers.size());
   std::cout << "The smallest number is " << min << ", the biggest " << max << "!\n" ;
}
