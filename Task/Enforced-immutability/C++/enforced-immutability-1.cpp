#include <iostream>

class MyOtherClass
{
public:
  const int m_x;
  MyOtherClass(const int initX = 0) : m_x(initX) { }

};

int main()
{
  MyOtherClass mocA, mocB(7);

  std::cout << mocA.m_x << std::endl; // displays 0, the default value given for MyOtherClass's constructor.
  std::cout << mocB.m_x << std::endl; // displays 7, the value we provided for the constructor for mocB.

  // Uncomment this, and the compile will fail; m_x is a const member.
  // mocB.m_x = 99;

  return 0;
}
