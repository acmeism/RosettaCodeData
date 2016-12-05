#include <iostream>
#include <istream>
#include <ostream>
#include <vector>

int main()
{
  // read values
  int dim1, dim2;
  std::cin >> dim1 >> dim2;

  // create array
  std::vector<std::vector<double> > array(dim1, std::vector<double>(dim2));

  // write element
  array[0][0] = 3.5;

  // output element
  std::cout << array[0][0] << std::endl;

  // the array is automatically freed at the end of main()
  return 0;
}
