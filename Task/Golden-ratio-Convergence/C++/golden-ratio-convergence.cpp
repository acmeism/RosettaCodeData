#include <iostream>
#include <cmath>
#include <iomanip>

using namespace std;

int main() {
    double oldPhi = 1.0, phi = 1.0, limit = 1e-5;
    int iters = 0;
    while (true) {
        phi = 1.0 + 1.0 / oldPhi;
        iters++;
        if (abs(phi - oldPhi) <= limit) break;
        oldPhi = phi;
    }
    cout.setf(ios::fixed);
    cout << "Final value of phi : " << setprecision(14) << phi << endl;
    double actualPhi = (1.0 + sqrt(5.0)) / 2.0;
    cout << "Number of iterations : "<< iters << endl;
    cout << "Error (approx) : " << setprecision(14) << phi - actualPhi << endl;
    return 0;
}
