#include <iostream>

int main()
{
  // Tür (German for door) in UTF8
  std::cout << char_length("\x54\xc3\xbc\x72", "de_DE.utf8") << "\n"; // outputs 3

  // Tür in ISO-8859-1
  std::cout << char_length("\x54\xfc\x72", "de_DE") << "\n"; // outputs 3
}
