#include <iostream>
#include <algorithm>
#include <vector>
#include <utility>

int gcd(int a, int b) {
    int c;
    while (b) {
        c = a;
        a = b;
        b = c % b;
    }
    return a;
}

int main() {
    using intpair = std::pair<int,int>;
    std::vector<intpair> pairs = {
        {21,15}, {17,23}, {36,12}, {18,29}, {60,15}
    };

    pairs.erase(
        std::remove_if(
            pairs.begin(),
            pairs.end(),
            [](const intpair& x) {
                return gcd(x.first, x.second) != 1;
            }
        ),
        pairs.end()
    );

    for (auto& x : pairs) {
        std::cout << "{" << x.first
                  << ", " << x.second
                  << "}" << std::endl;
    }

    return 0;
}
