template <class T>
int binsearch(const T array[], int len, T what)
{
  if (len == 0) return -1;
  int mid = len / 2;
  if (array[mid] == what) return mid;
  if (array[mid] < what) {
    int result = binsearch(array+mid+1, len-(mid+1), what);
    if (result == -1) return -1;
    else return result + mid+1;
  }
  if (array[mid] > what)
    return binsearch(array, mid, what);
}

#include <iostream>
int main()
{
  int array[] = {2, 3, 5, 6, 8};
  int result1 = binsearch(array, sizeof(array)/sizeof(int), 4),
      result2 = binsearch(array, sizeof(array)/sizeof(int), 8);
  if (result1 == -1) std::cout << "4 not found!" << std::endl;
  else std::cout << "4 found at " << result1 << std::endl;
  if (result2 == -1) std::cout << "8 not found!" << std::endl;
  else std::cout << "8 found at " << result2 << std::endl;

  return 0;
}
