#include <string>
#include <vector>
#include <iterator>
#include <algorithm>
#include <iostream>
#include <boost/tokenizer.hpp>
int main()
{
    std::string s = "Hello,How,Are,You,Today";
    boost::tokenizer<> tok(s);
    std::vector<std::string> v(tok.begin(), tok.end());
    copy(v.begin(), v.end(), std::ostream_iterator<std::string>(std::cout, "."))
    std::cout << '\n';
}
