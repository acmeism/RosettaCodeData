#include <algorithm>
#include <string>

constexpr bool is_palindrome(std::string_view s)
{
  return std::equal(s.begin(), s.begin()+s.length()/2, s.rbegin());
}
