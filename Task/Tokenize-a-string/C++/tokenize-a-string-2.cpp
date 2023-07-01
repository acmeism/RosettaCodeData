#include <string>
#include <locale>
#include <sstream>
#include <vector>
#include <iterator>
#include <iostream>
#include <algorithm>
struct comma_ws : std::ctype<char> {
    static const mask* make_table() {
    static std::vector<mask> v(classic_table(), classic_table() + table_size);
        v[','] |= space;  // comma will be classified as whitespace
        return &v[0];
    }
    comma_ws(std::size_t refs = 0) : ctype<char>(make_table(), false, refs) {}
};
int main()
{
    std::string s = "Hello,How,Are,You,Today";
    std::istringstream buf(s);
    buf.imbue(std::locale(buf.getloc(), new comma_ws));
    std::istream_iterator<std::string> beg(buf), end;
    std::vector<std::string> v(beg, end);
    copy(v.begin(), v.end(), std::ostream_iterator<std::string>(std::cout, "."));
    std::cout << '\n';
}
