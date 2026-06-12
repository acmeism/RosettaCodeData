#include <iostream>

std::ostream& operator<<(std::ostream& out, const std::string& str) {
    return out << str.c_str();
}

std::string textBetween(const std::string& source, const std::string& beg, const std::string& end) {
    size_t startIndex;
    if (beg == "start") {
        startIndex = 0;
    } else {
        startIndex = source.find(beg);
        if (startIndex == std::string::npos) {
            return "";
        }
        startIndex += beg.length();
    }

    size_t endIndex = source.find(end, startIndex);
    if (endIndex == std::string::npos || end == "end") {
        return source.substr(startIndex);
    }

    return source.substr(startIndex, endIndex - startIndex);
}

void print(const std::string& source, const std::string& beg, const std::string& end) {
    using namespace std;
    cout << "text: '" << source << "'\n";
    cout << "start: '" << beg << "'\n";
    cout << "end: '" << end << "'\n";
    cout << "result: '" << textBetween(source, beg, end) << "'\n";
    cout << '\n';
}

int main() {
    print("Hello Rosetta Code world", "Hello ", " world");
    print("Hello Rosetta Code world", "start", " world");
    print("Hello Rosetta Code world", "Hello ", "end");
    print("<text>Hello <span>Rosetta Code</span> world</text><table style=\"myTable\">", "<text>", "<table>");
    print("<table style=\"myTable\"><tr><td>hello world</td></tr></table>", "<table>", "</table>");
    print("The quick brown fox jumps over the lazy other fox", "quick ", " fox");
    print("One fish two fish red fish blue fish", "fish ", " red");
    print("FooBarBazFooBuxQuux", "Foo", "Foo");

    return 0;
}
