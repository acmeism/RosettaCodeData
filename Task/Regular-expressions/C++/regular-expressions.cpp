#include <iostream>
#include <string>
#include <iterator>
#include <regex>

int main()
{
  std::regex re(".* string$");
  std::string s = "Hi, I am a string";

  // match the complete string
  if (std::regex_match(s, re))
    std::cout << "The string matches.\n";
  else
    std::cout << "Oops - not found?\n";

  // match a substring
  std::regex re2(" a.*a");
  std::smatch match;
  if (std::regex_search(s, match, re2))
  {
    std::cout << "Matched " << match.length()
              << " characters starting at " << match.position() << ".\n";
    std::cout << "Matched character sequence: \""
              << match.str() << "\"\n";
  }
  else
  {
    std::cout << "Oops - not found?\n";
  }

  // replace a substring
  std::string dest_string;
  std::regex_replace(std::back_inserter(dest_string),
                       s.begin(), s.end(),
                       re2,
                       "'m now a changed");
  std::cout << dest_string << std::endl;
}
