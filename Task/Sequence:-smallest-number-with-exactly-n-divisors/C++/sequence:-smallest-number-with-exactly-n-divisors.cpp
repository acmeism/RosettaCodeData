#include <iostream>

#define MAX 15

using namespace std;

int count_divisors(int n) {
    int count = 0;
    for (int i = 1; i * i <= n; ++i) {
        if (!(n % i)) {
            if (i == n / i)
                count++;
            else
                count += 2;
        }
    }
    return count;
}

int main() {
    int i, k, n, seq[MAX];
    for (i = 0; i < MAX; ++i) seq[i] = 0;
    cout << "The first " << MAX << " terms of the sequence are:" << endl;
    for (i = 1, n = 0; n <  MAX; ++i) {
        k = count_divisors(i);
        if (k <= MAX && seq[k - 1] == 0) {
            seq[k - 1] = i;
            ++n;
        }
    }
    for (i = 0; i < MAX; ++i) cout << seq[i] << " ";
    cout << endl;
    return 0;
}
