// Boost
#include <cstdlib>
#include <string>
#include <boost/lexical_cast.hpp>

// inside a function or method...
std::string s = "12345";
int i = boost::lexical_cast<int>(s) + 1;
s = boost::lexical_cast<std::string>(i);
