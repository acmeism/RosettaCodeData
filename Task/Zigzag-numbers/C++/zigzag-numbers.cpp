#include <iostream>
#include <vector>
#include <algorithm>
#include <iterator>
#include <numeric>
#include <stdexcept>
#include <string>
#include <sstream>
#include <iomanip>

using namespace std;

bool isZigzag(const vector<int>& arr) {
    if (arr.size() < 2) {
        return true;
    }

    for (size_t i = 0; i < arr.size() - 1; ++i) {
        if (i % 2 == 0) { // even index i
            if (arr[i] >= arr[i + 1]) {
                return false;
            }
        } else { // odd index i
            if (arr[i] <= arr[i + 1]) {
                return false;
            }
        }
    }
    return true;
}

void swap(int& a, int& b) {
    int temp = a;
    a = b;
    b = temp;
}

void reverseArray(vector<int>& arr, int start, int end) {
    while (start < end) {
        swap(arr[start], arr[end]);
        start++;
        end--;
    }
}

bool nextZigzagPerm(vector<int>& arr) {
    if (arr.size() <= 1) {
        return false;
    }

    while (true) {
        // Find last index where arr[i] < arr[i+1]
        int i = -1;
        for (size_t idx = 0; idx < arr.size() - 1; ++idx) {
            if (arr[idx] < arr[idx + 1]) {
                i = idx;
            }
        }

        if (i == -1) {
            // Reverse the array
            reverseArray(arr, 0, arr.size() - 1);
            break;
        }

        // Find last index where arr[j] > arr[i]
        int j = i + 1;
        for (size_t idx = i + 1; idx < arr.size(); ++idx) {
            if (arr[idx] > arr[i]) {
                j = idx;
            }
        }

        // Swap elements at i and j
        swap(arr[i], arr[j]);

        // Reverse the subarray from i+1 to end
        reverseArray(arr, i + 1, arr.size() - 1);

        if (isZigzag(arr)) {
            return true;
        }
    }
    return false;
}

class Zigzags : public iterator<input_iterator_tag, vector<int>> {
private:
    int n;
    vector<int> state;
    bool hasNext;

public:
    Zigzags(int n) : n(n), hasNext(true) {
        state.resize(n);
        iota(state.begin(), state.end(), 1);
    }

    bool has_next() const {
        return hasNext;
    }

    vector<int> next() {
        if (!hasNext) {
            throw out_of_range("No more elements");
        }

        vector<int> result = state;
        hasNext = nextZigzagPerm(state);
        return result;
    }

    const vector<int>& peek() const {
        return state;
    }
};

void printPermutations(int n) {
    if (n < 3) {
        cout << "[";
        for (int i = 1; i <= n; ++i) {
            cout << i;
            if (i < n) cout << ", ";
        }
        cout << "]" << endl;
    } else {
        Zigzags zigzags(n);
        while (zigzags.has_next()) {
            vector<int> perm = zigzags.next();
            cout << "[";
            for (size_t i = 0; i < perm.size(); ++i) {
                cout << perm[i];
                if (i < perm.size() - 1) cout << ", ";
            }
            cout << "] ";
        }
        cout << endl;
    }
}

void printZigzagTotals(int nTotals) {
    vector<vector<long long>> zzn = {{1}};

    cout << "\nN     Zigzags" << endl;
    cout << "--------------------------------" << endl;
    cout << " 1    1" << endl;

    for (int m = 1; m < nTotals; ++m) {
        vector<long long> cumsum;
        long long total = 0;

        if (m % 2 == 0) {
            // Reverse iteration
            for (auto it = zzn.back().rbegin(); it != zzn.back().rend(); ++it) {
                total += *it;
                cumsum.push_back(total);
            }
            reverse(cumsum.begin(), cumsum.end());
            zzn.push_back(cumsum);
            zzn.back().push_back(0);
        } else {
            for (long long x : zzn.back()) {
                total += x;
                cumsum.push_back(total);
            }
            zzn.push_back({0});
            zzn.back().insert(zzn.back().end(), cumsum.begin(), cumsum.end());
        }

        long long sum = accumulate(zzn.back().begin(), zzn.back().end(), 0LL);
        cout << setw(2) << m + 1 << "    " << sum << endl;
    }
}

void testZigzags(int nListings, int nTotals) {
    for (int n = 1; n <= nListings; ++n) {
        cout << "\nZigZag Permutations for N = " << n << ":" << endl;
        printPermutations(n);
    }
    printZigzagTotals(nTotals);
}

int main() {
    testZigzags(5, 23);
    return 0;
}

