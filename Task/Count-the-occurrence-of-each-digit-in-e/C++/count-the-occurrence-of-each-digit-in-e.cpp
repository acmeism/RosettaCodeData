#include <iostream>
#include <vector>
#include <string>

int main() {
    const int n = 2000;

    std::vector<int> dcount(10, 0);  // Initialize all to 0
    dcount[2] = 1;                   // Set digit 2 count to 1

    std::vector<int> v(n, 1);

    // Main calculation loop
    for (int col = 0; col <= 2 * n; col++) {
        int a = n + 1;
        int c = 0;

        for (int i = 0; i < n; i++) {
            c += v[i] * 10;
            v[i] = c % a;
            c = c / a;
            a -= 1;
        }

        dcount[c]++;
    }

    for (int i = 0; i < dcount.size(); i++) {
        std::cout << " " << dcount[i];
    }
    std::cout << std::endl;

    return 0;
}
