#include <iostream>
#include <tuple>
#include <vector>

std::pair<int, int> tryPerm(int, int, const std::vector<int>&, int, int);

std::pair<int, int> checkSeq(int pos, const std::vector<int>& seq, int n, int minLen) {
    if (pos > minLen || seq[0] > n) return { minLen, 0 };
    else if (seq[0] == n)           return { pos, 1 };
    else if (pos < minLen)          return tryPerm(0, pos, seq, n, minLen);
    else                            return { minLen, 0 };
}

std::pair<int, int> tryPerm(int i, int pos, const std::vector<int>& seq, int n, int minLen) {
    if (i > pos) return { minLen, 0 };

    std::vector<int> seq2{ seq[0] + seq[i] };
    seq2.insert(seq2.end(), seq.cbegin(), seq.cend());
    auto res1 = checkSeq(pos + 1, seq2, n, minLen);
    auto res2 = tryPerm(i + 1, pos, seq, n, res1.first);

    if (res2.first < res1.first)       return res2;
    else if (res2.first == res1.first) return { res2.first, res1.second + res2.second };
    else                               throw std::runtime_error("tryPerm exception");
}

std::pair<int, int> initTryPerm(int x) {
    return tryPerm(0, 0, { 1 }, x, 12);
}

void findBrauer(int num) {
    auto res = initTryPerm(num);
    std::cout << '\n';
    std::cout << "N = " << num << '\n';
    std::cout << "Minimum length of chains: L(n)= " << res.first << '\n';
    std::cout << "Number of minimum length Brauer chains: " << res.second << '\n';
}

int main() {
    std::vector<int> nums{ 7, 14, 21, 29, 32, 42, 64, 47, 79, 191, 382, 379 };
    for (int i : nums) {
        findBrauer(i);
    }

    return 0;
}
