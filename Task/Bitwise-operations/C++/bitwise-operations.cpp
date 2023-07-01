#include <iostream>

void bitwise(int a, int b)
{
  std::cout << "a and b: " << (a & b)  << '\n'; // Note: parentheses are needed because & has lower precedence than <<
  std::cout << "a or b:  " << (a | b)  << '\n';
  std::cout << "a xor b: " << (a ^ b)  << '\n';
  std::cout << "not a:   " << ~a       << '\n';

  // Note: the C/C++ shift operators are not guaranteed to work if the shift count (that is, b)
  // is negative, or is greater or equal to the number of bits in the integer being shifted.
  std::cout << "a shl b: " << (a << b) << '\n'; // Note: "<<" is used both for output and for left shift
  std::cout << "a shr b: " << (a >> b) << '\n'; // typically arithmetic right shift, but not guaranteed
  unsigned int ua = a;
  std::cout << "a lsr b: " << (ua >> b) << '\n'; // logical right shift (guaranteed)

  // there are no rotation operators in C++, but as of c++20 there is a standard-library rotate function.
  // The rotate function works for all rotation amounts, but the integer being rotated must always be an
  // unsigned integer.
  std::cout << "a rol b: " << std::rotl(ua, b) << '\n';
  std::cout << "a ror b: " << std::rotr(ua, b) << '\n';

}
