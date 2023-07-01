#include <iostream>
#include <vector>
#include <algorithm>
#include <string>
#include <iterator>
#include <sstream>

int main() {
   std::string s = "rosetta code phrase reversal";
   std::cout << "Input : " << s << '\n'
             << "Input reversed : " << std::string(s.rbegin(), s.rend()) << '\n' ;
   std::istringstream is(s);
   std::vector<std::string> words(std::istream_iterator<std::string>(is), {});
   std::cout << "Each word reversed : " ;
   for(auto w : words)
      std::cout << std::string(w.rbegin(), w.rend()) << ' ';
   std::cout << '\n'
             << "Original word order reversed : " ;
   reverse_copy(words.begin(), words.end(), std::ostream_iterator<std::string>(std::cout, " "));
   std::cout << '\n' ;
}
