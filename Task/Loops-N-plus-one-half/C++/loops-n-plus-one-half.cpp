#include <iostream>

int main()
{
  int i;
  for (i = 1; i<=10 ; i++){
    std::cout << i;
    if (i < 10)
     std::cout << ", ";
  }
  return 0;
}
