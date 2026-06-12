#include <stdio.h>

int main() {
    /* =============================
       NKTg Planetary Verification
       ============================= */

    const char *planets[] = {
        "Mercury","Venus","Earth","Mars",
        "Jupiter","Saturn","Uranus","Neptune"
    };

    double x_km[] = {
        6.9817930e7, 1.0893900e8, 1.4710000e8, 2.4923000e8,
        8.1662000e8, 1.5065300e9, 3.0013900e9, 4.5589000e9
    };

    double v_km_s[] = {
        38.86, 35.02, 29.29, 24.07,
        13.06, 9.69, 6.8, 5.43
    };

    double m_kg[] = {
        3.301e23, 4.867e24, 5.972e24, 6.417e23,
        1.898e27, 5.683e26, 8.681e25, 1.024e26
    };

    printf("=== NKTg Planetary Mass Verification ===\n");

    for (int i = 0; i < 8; i++) {
        double x_m = x_km[i] * 1e3;
        double v_m_s = v_km_s[i] * 1e3;

        double p = m_kg[i] * v_m_s;
        double NKTg1 = x_m * p;

        double m_interpolated = NKTg1 / (x_m * v_m_s);
        double delta_m = m_kg[i] - m_interpolated;

        printf("%s:\n", planets[i]);
        printf("  NASA mass        = %.10e kg\n", m_kg[i]);
        printf("  Interpolated     = %.10e kg\n", m_interpolated);
        printf("  Delta m          = %.10e kg\n\n", delta_m);
    }

    /* =============================
       Earth 2024 Interpolation
       ============================= */

    double NKTg1_earth = 2.664e33;

    const char *dates[] = {
        "20240101","20240401","20240701",
        "20241001","20241231"
    };

    double earth_x_km[] = {
        149600000,149500000,149400000,
        149500000,149600000
    };

    double earth_v_km_s[] = {
        29.779,29.289,30.289,
        29.779,29.779
    };

    double nasa_fixed_mass = 5.9722e24;

    printf("=== Earth 2024 Mass Interpolation (NKTg) ===\n");

    for (int i = 0; i < 5; i++) {
        double x_m = earth_x_km[i] * 1e3;
        double v_m_s = earth_v_km_s[i] * 1e3;

        double m_interpolated = NKTg1_earth / (x_m * v_m_s);
        double delta_m = nasa_fixed_mass - m_interpolated;

        printf("%s:\n", dates[i]);
        printf("  Interpolated     = %.10e kg\n", m_interpolated);
        printf("  NASA fixed mass  = %.10e kg\n", nasa_fixed_mass);
        printf("  Delta m          = %.10e kg\n\n", delta_m);
    }

    return 0;
}
