#include <iostream>

int main()
{
  int square = 1, increment = 3;
  for (int door = 1; door <= 100; ++door)
  {
    std::cout << "door #" << door;
    if (door == square)
    {
      std::cout << " is open." << std::endl;
      square += increment;
      increment += 2;
    }
    else
      std::cout << " is closed." << std::endl;
  }
  return 0;
}
