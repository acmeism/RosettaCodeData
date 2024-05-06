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
    cout << "The first " << MAX << " terms of the sequence are:" << endl;
    for (int i = 1, next = 1; next <= MAX; ++i) {
        if (next == count_divisors(i)) {
            cout << i << " ";
            next++;
        }
    }
    cout << endl;
    return 0;
}
