#include <string>

int main()
{
  int* p;

  p = new int;    // allocate a single int, uninitialized
  delete p;       // deallocate it

  p = new int(2); // allocate a single int, initialized with 2
  delete p;       // deallocate it

  std::string* p2;

  p2 = new std::string; // allocate a single string, default-initialized
  delete p2;            // deallocate it

  p = new int[10]; // allocate an array of 10 ints, uninitialized
  delete[] p;      // deallocation of arrays must use delete[]

  p2 = new std::string[10]; // allocate an array of 10 strings, default-initialized
  delete[] p2;              // deallocate it
}
