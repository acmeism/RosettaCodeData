#include <iostream>
#include <vector>

constexpr int N = 2200;
constexpr int N2 = 2 * N * N;

int main() {
    using namespace std;

    vector<bool> found(N + 1);
    vector<bool> aabb(N2 + 1);

    int s = 3;

    for (int a = 1; a < N; ++a) {
        int aa = a * a;
        for (int b = 1; b < N; ++b) {
            aabb[aa + b * b] = true;
        }
    }

    for (int c = 1; c <= N; ++c) {
        int s1 = s;
        s += 2;
        int s2 = s;
        for (int d = c + 1; d <= N; ++d) {
            if (aabb[s1]) {
                found[d] = true;
            }
            s1 += s2;
            s2 += 2;
        }
    }

    cout << "The values of d <= " << N << " which can't be represented:" << endl;
    for (int d = 1; d <= N; ++d) {
        if (!found[d]) {
            cout << d << " ";
        }
    }
    cout << endl;

    return 0;
}
