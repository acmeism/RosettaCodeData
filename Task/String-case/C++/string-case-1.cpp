#include <algorithm>
#include <string>
#include <cctype>

/// \brief in-place convert string to upper case
/// \return ref to transformed string
void str_toupper(std::string &str) {
  std::transform(str.begin(),
                 str.end(),
                 str.begin(),
                 (int(*)(int)) std::toupper);
}

/// \brief in-place convert string to lower case
/// \return ref to transformed string
void str_tolower(std::string &str) {
  std::transform(str.begin(),
                 str.end(),
                 str.begin(),
                 (int(*)(int)) std::tolower);
}
