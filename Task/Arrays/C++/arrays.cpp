#include <array>
#include <vector>

// These headers are only needed for the demonstration
#include <algorithm>
#include <iostream>
#include <iterator>
#include <string>

// This is a template function that works for any array-like object
template <typename Array>
void demonstrate(Array& array)
{
  // Array element access
  array[2] = "Three";  // Fast, but unsafe - if the index is out of bounds you
                       // get undefined behaviour
  array.at(1) = "Two"; // *Slightly* less fast, but safe - if the index is out
                       // of bounds, an exception is thrown

  // Arrays can be used with standard algorithms
  std::reverse(begin(array), end(array));
  std::for_each(begin(array), end(array),
    [](typename Array::value_type const& element) // in C++14, you can just use auto
    {
      std::cout << element << ' ';
    });

  std::cout << '\n';
}

int main()
{
  // Compile-time sized fixed-size array
  auto fixed_size_array = std::array<std::string, 3>{ "One", "Four", "Eight" };
  // If you do not supply enough elements, the remainder are default-initialized

  // Dynamic array
  auto dynamic_array = std::vector<std::string>{ "One", "Four" };
  dynamic_array.push_back("Eight"); // Dynamically grows to accept new element

  // All types of arrays can be used more or less interchangeably
  demonstrate(fixed_size_array);
  demonstrate(dynamic_array);
}
