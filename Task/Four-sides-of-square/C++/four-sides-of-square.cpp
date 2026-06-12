#include <concepts>
#include <iostream>

// Print each element of a matrix according to a predicate.  It
// will print a '1' if the predicate function is true, otherwise '0'.
void PrintMatrix(std::predicate<int, int, int> auto f, int size)
{
  for(int y = 0; y < size; y++)
  {
    for(int x = 0; x < size; x++)
    {
      std::cout << " " << f(x, y, size);
    }
    std::cout << "\n";
  }
  std::cout << "\n";
}

int main()
{
  // a lambda to show the sides
  auto fourSides = [](int x, int y, int size)
  {
    return x == 0 || (y == 0) || (x == size - 1) || (y == size - 1);
  };

  PrintMatrix(fourSides, 8);
  PrintMatrix(fourSides, 9);
}

