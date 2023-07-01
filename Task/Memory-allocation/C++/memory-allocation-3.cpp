#include <new>

int main()
{
  union
  {
    int alignment_dummy; // make sure the block is correctly aligned for ints
    char data[2*sizeof(int)]; // enough space for 10 ints
  };
  int* p = new(&data) int(3); // construct an int at the beginning of data
  new(p+1) int(5); // construct another int directly following
}
