#include <iostream>
#include <cstdint>
#include <limits>

int main (int argc, char *argv[])
{
  std::cout << std::boolalpha
  << std::numeric_limits<std::int32_t>::is_modulo << '\n'
  << std::numeric_limits<std::uint32_t>::is_modulo << '\n' // always true
  << std::numeric_limits<std::int64_t>::is_modulo << '\n'
  << std::numeric_limits<std::uint64_t>::is_modulo << '\n' // always true
  << "Signed 32-bit:\n"
    << -(-2147483647-1) << '\n'
    << 2000000000 + 2000000000 << '\n'
    << -2147483647 - 2147483647 << '\n'
    << 46341 * 46341 << '\n'
    << (-2147483647-1) / -1 << '\n'
  << "Signed 64-bit:\n"
    << -(-9223372036854775807-1) << '\n'
    << 5000000000000000000+5000000000000000000 << '\n'
    << -9223372036854775807 - 9223372036854775807 << '\n'
    << 3037000500 * 3037000500 << '\n'
    << (-9223372036854775807-1) / -1 << '\n'
  << "Unsigned 32-bit:\n"
    << -4294967295U << '\n'
    << 3000000000U + 3000000000U << '\n'
    << 2147483647U - 4294967295U << '\n'
    << 65537U * 65537U << '\n'
  << "Unsigned 64-bit:\n"
    << -18446744073709551615LU << '\n'
    << 10000000000000000000LU + 10000000000000000000LU << '\n'
    << 9223372036854775807LU - 18446744073709551615LU << '\n'
    << 4294967296LU * 4294967296LU << '\n';
  return 0;
}
