#include <iostream>  // cout for printing
#include <algorithm> // for_each defined here
#include <vector>    // stl vector class

// create the function (print the square)
void print_square(int i) {
  std::cout << i*i << " ";
}

int main() {
  // create the array
  std::vector<int> ary;
  ary.push_back(1);
  ary.push_back(2);
  ary.push_back(3);
  ary.push_back(4);
  ary.push_back(5);
  // stl for_each
  std::for_each(ary.begin(),ary.end(),print_square);
  return 0;
}
//prints 1 4 9 16 25
