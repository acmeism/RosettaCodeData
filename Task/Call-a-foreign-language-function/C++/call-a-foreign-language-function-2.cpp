#include <cstdlib>  // for C memory management
#include <string>   // for C++ strings
#include <iostream> // for output

// C functions must be defined extern "C"
extern "C" char* strdup1(char const*);

// Fortran functions must also be defined extern "C" to prevent name
// mangling; in addition, all fortran names are converted to lowercase
// and get an undescore appended. Fortran takes all arguments by
// reference, which translates to pointers in C and C++ (C++
// references generally work, too, but that may depend on the C++
// compiler)
extern "C" double multiply_(double* x, double* y);

// to simplify the use and reduce the probability of errors, a simple
// inline forwarder like this can be used:
inline double multiply(double x, double y)
{
  return multiply_(&x, &y);
}

int main()
{
  std::string msg = "The product of 3 and 5 is ";

  // call to C function (note that this should not be assigned
  // directly to a C++ string, because strdup1 allocates memory, and
  // we would leak the memory if we wouldn't save the pointer itself
  char* msg2 = strdup1(msg.c_str());

  // C strings can be directly output to std::cout, so we don't need
  // to put it back into a string to output it.
  std::cout << msg2;

  // call the FORTRAN function (through the wrapper):
  std::cout << multiply(3, 5) << std::endl;

  // since strdup1 allocates with malloc, it must be deallocated with
  // free, not delete, nor delete[], nor operator delete
  std::free(msg2);
}
