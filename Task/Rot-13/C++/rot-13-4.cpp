#include <string>
#include <iostream>
#define rot13(c) (c >= 'A' && c <= 'Z')\
    ? (c - 'A' + 13) % 26 + 'A'\
    : (\
        (c >= 'a' && c <= 'z')\
            ? (c - 'a' + 13) % 26 + 'a'\
            : c\
    )

using namespace std;
int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);
    string str;
    while (getline(cin, str)) {
        for (auto& i : str) i = rot13(i);
        str += '\n';
        cout << str;
    }
    return 0;
}
