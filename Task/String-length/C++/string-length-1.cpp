#include <string> // (not <string.h>!)
using std::string;

int main()
{
  string s = "Hello, world!";
  string::size_type length = s.length(); // option 1: In Characters/Bytes
  string::size_type size = s.size();     // option 2: In Characters/Bytes
  // In bytes same as above since sizeof(char) == 1
  string::size_type bytes = s.length() * sizeof(string::value_type);
}
