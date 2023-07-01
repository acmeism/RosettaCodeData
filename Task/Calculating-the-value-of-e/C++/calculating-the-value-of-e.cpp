#include <iostream>
#include <iomanip>
#include <cmath>

using namespace std;

int main() {
    const double EPSILON = 1.0e-15;
    unsigned long long fact = 1;
    double e = 2.0, e0;
    int n = 2;
    do {
        e0 = e;
        fact *= n++;
        e += 1.0 / fact;
    }
    while (fabs(e - e0) >= EPSILON);
    cout << "e = " << setprecision(16) << e << endl;
    return 0;
}
