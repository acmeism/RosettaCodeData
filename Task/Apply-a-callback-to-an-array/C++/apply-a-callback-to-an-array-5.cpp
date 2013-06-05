#include <vector>
#include <iostream>
#include <algorithm>
#include <iterator>

int main() {
   std::vector<int> intVec(10);
   std::iota(std::begin(intVec), std::end(intVec), 1 ); // Fill the vector
   std::transform(std::begin(intVec) , std::end(intVec), std::begin(intVec),
	 [](int i) { return i * i ; } ); // Transform it with closures
   std::copy(std::begin(intVec), end(intVec) ,
	 std::ostream_iterator<int>(std::cout, " "));
   std::cout << std::endl;
   return 0;
}
