#include <cstdlib>
#include <iostream>
#include <tuple>

using namespace std;

int gcd(int a, int b) {
    a = abs(a);
    b = abs(b);
    while (b != 0) {
        tie(a, b) = make_tuple(b, a % b);
    }
    return a;
}

int lcm(int a, int b) {
    int c = gcd(a, b);
    return c == 0 ? 0 : a / c * b;
}

int main() {
    cout << "The least common multiple of 12 and 18 is " << lcm(12, 18)
         << " ,\n"
         << "and the greatest common divisor " << gcd(12, 18) << " !" << endl;
    return 0;
}
