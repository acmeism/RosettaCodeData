#include <algorithm>
#include <iostream>

int main() {
    std::string str("AABBBC");
    int count = 0;
    do {
        std::cout << str << (++count % 10 == 0 ? '\n' : ' ');
    } while (std::next_permutation(str.begin(), str.end()));
}
