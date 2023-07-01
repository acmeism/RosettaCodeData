#include <iomanip>
#include <iostream>

using namespace std;

string replaceFirst(string &s, const string &target, const string &replace) {
    auto pos = s.find(target);
    if (pos == string::npos) return s;
    return s.replace(pos, target.length(), replace);
}

int main() {

    // string creation
    string x = "hello world";

    // reassign string (no garbage collection)
    x = "";

    // string assignment with a null byte
    x = "ab\0";
    cout << x << '\n';
    cout << x.length() << '\n';

    // string comparison
    if (x == "hello") {
        cout << "equal\n";
    } else {
        cout << "not equal\n";
    }
    if (x < "bc") {
        cout << "x is lexigraphically less than 'bc'\n";
    }

    // string cloning
    auto y = x;
    cout << boolalpha << (x == y) << '\n';
    cout << boolalpha << (&x == &y) << '\n';

    // check if empty
    string empty = "";
    if (empty.empty()) {
        cout << "String is empty\n";
    }

    // append a byte
    x = "helloworld";
    x += (char)83;
    cout << x << '\n';

    // substring
    auto slice = x.substr(5, 5);
    cout << slice << '\n';

    // replace bytes
    auto greeting = replaceFirst(x, "worldS", "");
    cout << greeting << '\n';

    // join strings
    auto join = greeting + ' ' + slice;
    cout << join << '\n';

    return 0;
}
