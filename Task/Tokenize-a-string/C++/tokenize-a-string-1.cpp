#include <string>
#include <sstream>
#include <vector>
#include <iterator>
#include <iostream>
#include <algorithm>
int main()
{
    std::string s = "Hello,How,Are,You,Today";
    std::vector<std::string> v;
    std::istringstream buf(s);
    for(std::string token; getline(buf, token, ','); )
        v.push_back(token);
    copy(v.begin(), v.end(), std::ostream_iterator<std::string>(std::cout, "."));
    std::cout << '\n';
}
