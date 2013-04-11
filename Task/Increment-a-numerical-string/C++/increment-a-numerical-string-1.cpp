// standard C++ string stream operators
#include <cstdlib>
#include <string>
#include <sstream>

// inside a function or method...
std::string s = "12345";

int i;
std::istringstream(s) >> i;
i++;
//or:
//int i = std::atoi(s.c_str()) + 1;

std::ostringstream oss;
if (oss << i) s = oss.str();
