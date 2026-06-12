#include <algorithm>
#include <iostream>

int main() {
    std::string s = "Now is the time for all good men "
                    "to come to the aid of our country.";

    std::cout << s << std::endl;
    std::sort(s.begin(), s.end());
    std::cout << s << std::endl;
    return 0;
}
