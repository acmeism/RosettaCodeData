#include <string>
#include <algorithm>

bool is_palindrome(std::string const& s)
{
  return std::equal(s.begin(), s.end(), s.rbegin());
}
