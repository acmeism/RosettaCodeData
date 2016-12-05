#include <iostream>
#include <istream>
#include <ostream>

int main()
{
  // read values
  int dim1, dim2;
  std::cin >> dim1 >> dim2;

  // create array
  double* array_data = new double[dim1*dim2];
  double** array = new double*[dim1];
  for (int i = 0; i < dim1; ++i)
    array[i] = array_data + dim2*i;

  // write element
  array[0][0] = 3.5;

  // output element
  std::cout << array[0][0] << std::endl;

  // get rid of array
  delete[] array;
  delete[] array_data;

  return 0;
}
