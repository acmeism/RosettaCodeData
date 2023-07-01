#include <map>
#include <iostream>
#include <string>

int main()
{
  std::map<char, std::string> rep =
    {{'a', "DCaBA"}, // replacement string is reversed
     {'b', "E"},
     {'r', "Fr"}};

  std::string magic = "abracadabra";

  for(auto it = magic.begin(); it != magic.end(); ++it)
  {
    if(auto f = rep.find(*it); f != rep.end() && !f->second.empty())
    {
      *it = f->second.back();
      f->second.pop_back();
    }
  }

  std::cout << magic << "\n";
}
