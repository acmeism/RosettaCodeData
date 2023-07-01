#include <algorithm>
#include <iostream>
#include <string>
#include <vector>

static void printVerse(const std::string& name) {
    std::string x = name;
    std::transform(x.begin(), x.end(), x.begin(), ::tolower);
    x[0] = toupper(x[0]);

    std::string y;
    switch (x[0]) {
    case 'A':
    case 'E':
    case 'I':
    case 'O':
    case 'U':
        y = x;
        std::transform(y.begin(), y.end(), y.begin(), ::tolower);
        break;
    default:
        y = x.substr(1);
        break;
    }

    std::string b("b" + y);
    std::string f("f" + y);
    std::string m("m" + y);

    switch (x[0]) {
    case 'B':
        b = y;
        break;
    case 'F':
        f = y;
        break;
    case 'M':
        m = y;
        break;
    default:
        break;
    }

    printf("%s, %s, bo-%s\n", x.c_str(), x.c_str(), b.c_str());
    printf("Banana-fana fo-%s\n", f.c_str());
    printf("Fee-fi-mo-%s\n", m.c_str());
    printf("%s!\n\n", x.c_str());
}

int main() {
    using namespace std;

    vector<string> nameList{ "Gary", "Earl", "Billy", "Felix", "Mary", "Steve" };
    for (auto& name : nameList) {
        printVerse(name);
    }

    return 0;
}
