// Factorization by trial division in C++11

#include <iostream>
#include <vector>

using long_pair = std::pair<long,long>;
using lp_vec = std::vector<long_pair>;

lp_vec factorize(long n)
{
    lp_vec fs;
    int cnt = 0;
    for (;n%2==0; n/=2) cnt++;    // optimized by compiler
    if (cnt > 0)
        fs.push_back({2, cnt});
    for (long i=3; i*i<=n; i+=2) {
        cnt = 0;
        for (;n%i==0; n/=i) cnt++;
        if (cnt>0)
            fs.push_back({i, cnt});
    }
    if (n>1)
        fs.push_back({n, 1});
    return fs;
}

int main() {
    long n;
    std::cin >> n;
    auto fs = factorize(n);
    for (auto fp : fs) {
        std::cout << fp.first << "^" << fp.second << "\n";
    }
    return 0;
}
