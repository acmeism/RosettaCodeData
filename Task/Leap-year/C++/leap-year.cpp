#include <iostream>

bool is_leap_year(int year) {
  return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
}

int main() {
  for (auto year : {1900, 1994, 1996, 1997, 2000}) {
    std::cout << year << (is_leap_year(year) ? " is" : " is not") << " a leap year.\n";
  }
}
