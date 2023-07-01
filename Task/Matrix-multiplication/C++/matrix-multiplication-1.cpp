#include <iostream>
#include <blitz/tinymat.h>

int main()
{
  using namespace blitz;

  TinyMatrix<double,3,3> A, B, C;

  A = 1, 2, 3,
      4, 5, 6,
      7, 8, 9;

  B = 1, 0, 0,
      0, 1, 0,
      0, 0, 1;

  C = product(A, B);

  std::cout << C << std::endl;
}
