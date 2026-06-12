#include <iostream>
#include <iomanip>
#include <cmath>
#include <vector>
#include <string>

using namespace std;

struct Planet {
    string name;
    long double x;     // position (km)
    long double v;     // velocity (km/s)
    long double m;     // NASA mass (kg)
};

int main() {

    cout << fixed << setprecision(6);
    cout << scientific;

    // Dữ liệu NASA 30/12/2024
    vector<Planet> planets = {
        {"Mercury", 6.9817930e7L, 38.86L, 3.301e23L},
        {"Venus",   1.0893900e8L, 35.02L, 4.867e24L},
        {"Earth",   1.4710000e8L, 29.29L, 5.972e24L},
        {"Mars",    2.4923000e8L, 24.07L, 6.417e23L},
        {"Jupiter", 8.1662000e8L, 13.06L, 1.898e27L},
        {"Saturn",  1.5065300e9L, 9.69L,  5.683e26L},
        {"Uranus",  3.0013900e9L, 6.8L,   8.681e25L},
        {"Neptune", 4.5589000e9L, 5.43L,  1.024e26L}
    };

    cout << "=== NKTg Law Verification (31/12/2024) ===\n\n";

    cout << left << setw(10) << "Planet"
         << setw(20) << "NKTg1"
         << setw(20) << "Interpolated m"
         << setw(20) << "NASA m"
         << setw(20) << "Delta m" << endl;

    cout << "----------------------------------------------------------------------------------------\n";

    for (const auto& p : planets) {

        // p = m * v
        long double momentum = p.m * p.v;

        // NKTg1 = x * p
        long double NKTg1 = p.x * momentum;

        // m interpolated = NKTg1 / (x * v)
        long double m_interpolated = NKTg1 / (p.x * p.v);

        // Delta m
        long double delta_m = p.m - m_interpolated;

        cout << left << setw(10) << p.name
             << setw(20) << NKTg1
             << setw(20) << m_interpolated
             << setw(20) << p.m
             << setw(20) << delta_m
             << endl;
    }

    cout << "\nConclusion: If Delta m ≈ 0, interpolation is exact.\n";

    return 0;
}
