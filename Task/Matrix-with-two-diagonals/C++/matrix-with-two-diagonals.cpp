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
  // a lambda to create diagonals
  auto diagonals = [](int x, int y, int size)
  {
    return x == y || ((size - x - 1) == y);
  };

  PrintMatrix(diagonals, 8);
  PrintMatrix(diagonals, 9);
}

