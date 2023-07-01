#include <iostream>

int main()
{
  // a numeric literal with decimal point is a double
  auto double1 = 2.5;

  // an 'f' of 'F' suffix means the literal is a flaot
  auto float1 = 2.5f;

  // an 'l' or 'L' suffix means a long double
  auto longdouble1 = 2.5l;

  // a number after an 'e' or 'E' is the base 10 exponent
  auto double2 = 2.5e-3;
  auto float2 = 2.5e3f;

  // a '0x' prefix means the literal is hexadecimal. the 'p' is base 2 the exponent
  auto double3 = 0x1p4;
  auto float3 = 0xbeefp-8f;

  std::cout << "\ndouble1: " << double1;
  std::cout << "\nfloat1: " << float1;
  std::cout << "\nlongdouble1: " << longdouble1;
  std::cout << "\ndouble2: " << double2;
  std::cout << "\nfloat2: " << float2;
  std::cout << "\ndouble3: " << double3;
  std::cout << "\nfloat3: " << float3;
  std::cout << "\n";
}
