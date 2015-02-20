#include <iostream>
#include <sstream>
#include <string>
#include <boost/multiprecision/cpp_int.hpp>

using big_int = boost::multiprecision::cpp_int;

big_int ipow(big_int base, big_int exp) {
  big_int result(1);
  while (exp) {
    if (exp & 1) {
      result *= base;
    }
    exp >>= 1;
    base *= base;
  }
  return result;
}

big_int ackermann(unsigned m, unsigned n) {
  static big_int (*ack)(unsigned, big_int) =
      [](unsigned m, big_int n)->big_int {
    switch (m) {
    case 0:
      return n + 1;
    case 1:
      return n + 2;
    case 2:
      return 3 + 2 * n;
    case 3:
      return 5 + 8 * (ipow(big_int(2), n) - 1);
    default:
      return n == 0 ? ack(m - 1, big_int(1)) : ack(m - 1, ack(m, n - 1));
    }
  };
  return ack(m, big_int(n));
}

int main() {
  for (unsigned m = 0; m < 4; ++m) {
    for (unsigned n = 0; n < 10; ++n) {
      std::cout << "A(" << m << ", " << n << ") = " << ackermann(m, n) << "\n";
    }
  }

  std::cout << "A(4, 1) = " << ackermann(4, 1) << "\n";

  std::stringstream ss;
  ss << ackermann(4, 2);
  auto text = ss.str();
  std::cout << "A(4, 2) = (" << text.length() << " digits)\n"
            << text.substr(0, 80) << "\n...\n"
            << text.substr(text.length() - 80) << "\n";
}
