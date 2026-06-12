#include <iostream>
#include <string>
#include <vector>
#include <algorithm>

std::string lcs(const std::vector<std::string>& strs) {
    std::vector<std::string::const_reverse_iterator> backs;
    std::string s;

    if (strs.size() == 0) return "";
    if (strs.size() == 1) return strs[0];

    for (auto& str : strs) backs.push_back(str.crbegin());

    while (backs[0] != strs[0].crend()) {
        char ch = *backs[0]++;
        for (std::size_t i = 1; i<strs.size(); i++) {
            if (backs[i] == strs[i].crend()) goto done;
            if (*backs[i] != ch) goto done;
            backs[i]++;
        }
        s.push_back(ch);
    }

done:
    reverse(s.begin(), s.end());
    return s;
}

void test(const std::vector<std::string>& strs) {
    std::cout << "[";
    for (std::size_t i = 0; i<strs.size(); i++) {
        std::cout << '"' << strs[i] << '"';
        if (i != strs.size()-1) std::cout << ", ";
    }
    std::cout << "] -> `" << lcs(strs) << "`\n";
}

int main() {
    std::vector<std::string> t1 = {"baabababc", "baabc", "bbabc"};
    std::vector<std::string> t2 = {"baabababc", "baabc", "bbazc"};
    std::vector<std::string> t3 =
        {"Sunday", "Monday", "Tuesday", "Wednesday", "Friday", "Saturday"};
    std::vector<std::string> t4 = {"longest", "common", "suffix"};
    std::vector<std::string> t5 = {""};
    std::vector<std::string> t6 = {};
    std::vector<std::string> t7 = {"foo", "foo", "foo", "foo"};

    std::vector<std::vector<std::string>> tests = {t1,t2,t3,t4,t5,t6,t7};

    for (auto t : tests) test(t);
    return 0;
}
