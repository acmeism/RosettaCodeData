#include <iostream>

template<int max, int min> struct bottle_countdown
{
  static const int middle = (min + max)/2;
  static void print()
  {
    bottle_countdown<max, middle+1>::print();
    bottle_countdown<middle, min>::print();
  }
};

template<int value> struct bottle_countdown<value, value>
{
  static void print()
  {
    std::cout << value << " bottles of beer on the wall\n"
              << value << " bottles of beer\n"
              << "Take one down, pass it around\n"
              << value-1 << " bottles of beer\n\n";
  }
};

int main()
{
  bottle_countdown<100, 1>::print();
  return 0;
}
