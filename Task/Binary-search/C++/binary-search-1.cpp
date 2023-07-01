template <class T> int binsearch(const T array[], int low, int high, T value) {
    if (high < low) {
        return -1;
    }
    auto mid = (low + high) / 2;
    if (value < array[mid]) {
        return binsearch(array, low, mid - 1, value);
    } else if (value > array[mid]) {
        return binsearch(array, mid + 1, high, value);
    }
    return mid;
}

#include <iostream>
int main()
{
  int array[] = {2, 3, 5, 6, 8};
  int result1 = binsearch(array, 0, sizeof(array)/sizeof(int), 4),
      result2 = binsearch(array, 0, sizeof(array)/sizeof(int), 8);
  if (result1 == -1) std::cout << "4 not found!" << std::endl;
  else std::cout << "4 found at " << result1 << std::endl;
  if (result2 == -1) std::cout << "8 not found!" << std::endl;
  else std::cout << "8 found at " << result2 << std::endl;

  return 0;
}
