#include <algorithm>
#include <iostream>

int countJewels(const std::string& s, const std::string& j) {
    int count = 0;
    for (char c : s) {
        if (j.find(c) != std::string::npos) {
            count++;
        }
    }
    return count;
}

int main() {
    using namespace std;

    cout << countJewels("aAAbbbb", "aA") << endl;
    cout << countJewels("ZZ", "z") << endl;

    return 0;
}
