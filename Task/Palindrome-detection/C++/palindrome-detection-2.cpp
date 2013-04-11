#include <string>
#include <algorithm>

bool is_palindrome(std::string const& s)
{
  return std::equal(s.begin(), s.begin()+s.length()/2, s.rbegin());
}
