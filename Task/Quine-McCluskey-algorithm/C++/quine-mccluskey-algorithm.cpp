#include <iostream>
#include <vector>
#include <string>
#include <algorithm>
#include <cmath>
#include <set>

struct SetType {
    std::vector<std::string> items;
};

std::string b2s(int i, int vars) {
    std::string s = "";
    for (int k = 0; k < vars; k++) {
        s = ( (i & 1) ? "1" : "0" ) + s;
        i >>= 1;
    }
    return s;
}

int bitCount(const std::string& s) {
    int count = 0;
    for (char c : s) {
        if (c == '1') count++;
    }
    return count;
}

std::string merge(const std::string& i, const std::string& j) {
    int len = std::min(i.size(), j.size());
    int difCnt = 0;
    std::string s = "";
    for (int k = 0; k < len; k++) {
        char a = i[k], b = j[k];
        if (a == 'X' || b == 'X') {
            if (a != b) {
                return "";
            }
            s += a;
        } else if (a != b) {
            difCnt++;
            if (difCnt > 1) {
                return "";
            }
            s += 'X';
        } else {
            s += a;
        }
    }
    return s;
}

void addToSet(SetType* s, const std::string& item) {
    for (const auto& str : s->items) {
        if (str == item) {
            return;
        }
    }
    s->items.push_back(item);
}

bool inSet(const SetType& s, const std::string& item) {
    for (const auto& str : s.items) {
        if (str == item) {
            return true;
        }
    }
    return false;
}

void unionSets(SetType* dest, const SetType& src) {
    for (const auto& item : src.items) {
        addToSet(dest, item);
    }
}

void computePrimes(const SetType& cubes, int vars, SetType* primes) {
    std::vector<SetType> sigma(vars + 1);
    int sigmaCount = 0;

    for (int j = 0; j <= vars; j++) {
        for (const auto& cube : cubes.items) {
            if (bitCount(cube) == j) {
                addToSet(&sigma[j], cube);
            }
        }
        if (sigma[j].items.size() > 0) {
            sigmaCount = j + 1;
        }
    }

    primes->items.clear();

    while (sigmaCount > 0) {
        std::vector<SetType> nsigma(sigmaCount - 1);
        SetType redundant;

        for (int i = 0; i < sigmaCount - 1; i++) {
            SetType& c1 = sigma[i];
            SetType& c2 = sigma[i + 1];
            SetType nc;

            for (const auto& a : c1.items) {
                for (const auto& b : c2.items) {
                    std::string m = merge(a, b);
                    if (!m.empty()) {
                        addToSet(&nc, m);
                        addToSet(&redundant, a);
                        addToSet(&redundant, b);
                    }
                }
            }
            nsigma[i] = nc;
        }

        for (int i = 0; i < sigmaCount; i++) {
            for (const auto& cube : sigma[i].items) {
                if (!inSet(redundant, cube)) {
                    addToSet(primes, cube);
                }
            }
        }

        sigma = nsigma;
        sigmaCount = nsigma.size();
    }
}

void activePrimes(int cubesel, const SetType& primes, SetType* result) {
    result->items.clear();
    std::string s = b2s(cubesel, primes.items.size());
    for (int i = 0; i < primes.items.size(); i++) {
        if (s[i] == '1') {
            addToSet(result, primes.items[i]);
        }
    }
}

bool isCover(const std::string& prime, const std::string& one) {
    int len = std::min(prime.size(), one.size());
    for (int i = 0; i < len; i++) {
        char p = prime[i], o = one[i];
        if (p != 'X' && p != o) {
            return false;
        }
    }
    return true;
}

bool isFullCover(const SetType& allPrimes, const SetType& ones) {
    for (const auto& one : ones.items) {
        bool covered = false;
        for (const auto& prime : allPrimes.items) {
            if (isCover(prime, one)) {
                covered = true;
                break;
            }
        }
        if (!covered) {
            return false;
        }
    }
    return true;
}

void unateCover(const SetType& primes, const SetType& ones, SetType* result) {
    int minCount = 1000;
    int minSel = -1;
    SetType active;

    int total = (1 << primes.items.size());
    for (int cubesel = 0; cubesel < total; cubesel++) {
        activePrimes(cubesel, primes, &active);
        if (isFullCover(active, ones)) {
            int cnt = 0;
            std::string binRep = b2s(cubesel, primes.items.size());
            for (char c : binRep) {
                if (c == '1') cnt++;
            }
            if (cnt < minCount) {
                minCount = cnt;
                minSel = cubesel;
            }
        }
    }

    if (minSel != -1) {
        activePrimes(minSel, primes, result);
    } else {
        result->items.clear();
    }
}

void qm(const std::vector<int>& ones, const std::vector<int>& zeros, const std::vector<int>& dc, SetType& result) {
    if (ones.empty() && zeros.empty() && dc.empty()) {
        return;
    }

    int maxVal = 0;
    for (int val : ones) if (val > maxVal) maxVal = val;
    for (int val : zeros) if (val > maxVal) maxVal = val;
    for (int val : dc) if (val > maxVal) maxVal = val;

    int numvars = 0;
    if (maxVal == 0) {
        numvars = 1;
    } else {
        int tmp = maxVal;
        while (tmp) {
            numvars++;
            tmp >>= 1;
        }
    }

    SetType onesSet;
    SetType zerosSet;
    SetType dcSet;

    for (int val : ones) {
        addToSet(&onesSet, b2s(val, numvars));
    }
    for (int val : zeros) {
        addToSet(&zerosSet, b2s(val, numvars));
    }
    for (int val : dc) {
        addToSet(&dcSet, b2s(val, numvars));
    }

    SetType cubes;
    unionSets(&cubes, onesSet);
    unionSets(&cubes, dcSet);

    SetType primes;
    computePrimes(cubes, numvars, &primes);

    unateCover(primes, onesSet, &result);
}

int main() {
    std::vector<int> ones = {1, 2, 5};
    std::vector<int> zeros = {};
    std::vector<int> dc = {0, 7};

    SetType result;
    qm(ones, zeros, dc, result);

    for (const auto& item : result.items) {
        std::cout << item << " ";
    }
    std::cout << std::endl;

    return 0;
}
