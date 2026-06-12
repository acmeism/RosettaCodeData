#include <algorithm>
#include <chrono>
#include <iostream>
#include <vector>

int ulam(int n) {
    std::vector<int> ulams{1, 2};
    std::vector<int> sieve{1, 1};
    for (int u = 2; ulams.size() < n; ) {
        sieve.resize(u + ulams[ulams.size() - 2], 0);
        for (int i = 0; i < ulams.size() - 1; ++i)
            ++sieve[u + ulams[i] - 1];
        auto it = std::find(sieve.begin() + u, sieve.end(), 1);
        if (it == sieve.end())
            return -1;
        u = (it - sieve.begin()) + 1;
        ulams.push_back(u);
    }
    return ulams[n - 1];
}

int main() {
    auto start = std::chrono::high_resolution_clock::now();
    for (int n = 1; n <= 100000; n *= 10)
        std::cout << "Ulam(" << n << ") = " << ulam(n) << '\n';
    auto end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> duration(end - start);
    std::cout << "Elapsed time: " << duration.count() << " seconds\n";
}
