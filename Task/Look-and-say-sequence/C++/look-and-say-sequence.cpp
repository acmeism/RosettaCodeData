#include <iostream>
#include <sstream>
#include <string>

std::string lookandsay(const std::string& s)
{
    std::ostringstream r;

    for (std::size_t i = 0; i != s.length();) {
        auto new_i = s.find_first_not_of(s[i], i + 1);

        if (new_i == std::string::npos)
            new_i = s.length();

        r << new_i - i << s[i];
        i = new_i;
    }
    return r.str();
}

int main()
{
    std::string laf = "1";

    std::cout << laf << '\n';
    for (int i = 0; i < 10; ++i) {
        laf = lookandsay(laf);
        std::cout << laf << '\n';
    }
}
